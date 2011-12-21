require 'rubygems'
require 'rake'
require 'rake/clean'
require 'bundler'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

require 'bundler/setup'

spec = load File.expand_path(File.dirname(__FILE__) + '/data-cells.gemspec')

task :default => [:test, :pkg]

RSpec::Core::RakeTask.new

