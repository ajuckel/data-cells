Data Cells
==========

Porting the idea of spreadsheet cells into an object oriented
programing language.

I never used the original CLOS cells much, but it seems like a useful
abstraction to bring into a Ruby class model.  I'm still a bit hazy on
how I'd like the syntax to play out, and this is obviously a very
early cut.  Almost no functionality is present yet.  It'll happily
fall into an infinite loop if you declare circular dependencies in
your cells.  Currently, Ruby 1.9 is required, though that may change
in the future.

Here's an example of the API so far:

    jruby-1.6.5 :001 > require 'data-cells'
     => true 
    jruby-1.6.5 :002 > class Temperature
    jruby-1.6.5 :003?>   include DataCells
    jruby-1.6.5 :004?>   data_cells :f, :c
    jruby-1.6.5 :005?>   end
     => [:f, :c] 
    jruby-1.6.5 :006 > t = Temperature.new
     => #<Temperature:0xcf546f8> 
    jruby-1.6.5 :007 > t.f = 32
     => 32 
    jruby-1.6.5 :008 > t.c = lambda { |f| (f - 32)*5/9 }
     => #<Proc:0x654f5021@(irb):8 (lambda)> 
    jruby-1.6.5 :009 > t.c
     => 0 
    jruby-1.6.5 :010 > t.f = 40
     => 40 
    jruby-1.6.5 :011 > t.c
     => 4 
    jruby-1.6.5 :012 > t.f = 212
     => 212 
    jruby-1.6.5 :013 > t.c
     => 100 
    jruby-1.6.5 :014 > t.f = 100
     => 100 
    jruby-1.6.5 :015 > t.c
     => 37 


