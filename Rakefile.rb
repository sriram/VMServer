require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name        = "vmserver"
    gemspec.summary     = "A gem to simplify VMServer handling from ruby"
    gemspec.description = "This gem simplifies the interaction of ruby code with VMServer if you need to automate the process."
    gemspec.email       = "sriram.varahan@gmail.com"
    gemspec.homepage    = "http://github.com/sriram/vmserver"
    gemspec.authors     = ["Sriram Varahan"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  p "Jeweler not available. Install it with: gem install jeweler"
end
