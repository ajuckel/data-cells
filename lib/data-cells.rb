#
# Note: this class is not at all thread safe, and you should
# be wary of accessing or modifying data cells from multiple
# threads
class Cell
  attr_accessor :cache, :listeners
  def initialize(owner)
    @owner = owner
    @dirty = true
    self.listeners = []
  end
  def owner
    @owner
  end
  def dirty?
    @dirty
  end
  def make_dirty
    @dirty = true
    self.listeners.each { |l| l.make_dirty }
  end
  def value
    @value.call
  end
  def value_for proc, needed_values
    if self.dirty?
      args = needed_values.map { |msg| @owner.send(msg) }
      self.cache = proc.call *args
      @dirty = false
    end
    self.cache
  end
  def add_listener cell
    self.listeners << cell
  end
  def listen_to(msg)
    other_cell = DataCells.cell_for owner, msg
    other_cell.add_listener self
  end
  def value=(new_value)
    if new_value.is_a? Proc
      @value = runner_for new_value
    else
      @value = lambda { new_value }
    end
    self.listeners.each { |l| l.make_dirty }
  end
  private
  def runner_for proc
    needed_values = proc.parameters.map { |spec| spec[1] }
    needed_values.each do |msg|
      self.listen_to msg
    end
    runner = lambda do
      self.value_for proc, needed_values
    end
    runner
  end
end

module DataCells
  def self.cell_handle cell_name
    "_cell_handle_#{cell_name}"
  end
  def self.cell_for owner, cell_name
    owner.send(cell_handle(cell_name))
  end
  def self.included mod
    mod.instance_eval do
      def data_cells(*cells)
        if @data_cells.nil?
          @data_cells = []
        end
        cells.each do |cell_name|
          cell_ivar = "@_cell_#{cell_name}"
          cell_handle = DataCells.cell_handle cell_name
          @data_cells << cell_name
          define_method(cell_handle) do
            instance_variable_get cell_ivar
          end
          define_method(cell_name) do
            cell = self.send(cell_handle)
            cell.nil? ? nil : cell.value
          end
          define_method("#{cell_name}=") do |val|
            cell = self.send(cell_handle.to_s)
            if cell.nil?
              cell = Cell.new self
              instance_variable_set cell_ivar, cell
            end
            cell.value = val
            cell.value
          end
        end
      end
    end
  end
end
