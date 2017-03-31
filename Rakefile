require "rake"
require "rake/testtask"

begin
  require "pry"
rescue LoadError
end

desc "Show the list of Rake tasks (rake -T)"
task :help do
  sh "rake -T"
end

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)

  task :default => :spec
rescue LoadError
  # no rspec available
end
