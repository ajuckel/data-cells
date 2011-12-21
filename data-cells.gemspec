Gem::Specification.new do |gem|
  gem.name = 'data-cells'
  gem.version = '0.0.1'
  gem.summary = 'Data attributes that can be simple values or blocks referencing other cells'
  gem.description = <<-DESC
A data cell in your class is similar to a cell in a spreadsheet.  It may contain
a simple value, or may contain a formula referencing other cells.  Formula-based
cells are only computed when their ancestor cells change.
  DESC
  gem.authors = ['Anthony Juckel']
  gem.email = 'ajuckel@gmail.com'
  gem.homepage = 'http://github.com/ajuckel/data-cells'
  gem.files = Dir['lib/**/*.rb']
end
