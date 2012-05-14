require 'cucumber/rake/task'
require 'rake/testtask'
require 'rspec/core/rake_task'

desc "Run specs"
RSpec::Core::RakeTask.new(:specs) do |t|
  t.pattern = "./spec/**/*_spec.rb" # don't need this, it's default.
  t.verbose = true
  t.ruby_opts = '-Iapp'
  ENV['RACK_ENV'] = "test"
end


Cucumber::Rake::Task.new :cucumber do |task|
  task.cucumber_opts = ['features']
end

Rake::TestTask.new :test do |t|
  t.test_files = Dir.glob 'test/**/*_test.rb'
  t.verbose = true
  t.warning = true
  t.libs << 'app'
end

desc 'Run Development Server'
task :run, :env do |t, args|
  environment = args[:env]
  ENV['RACK_ENV'] = environment
  sh %{rackup -I app config.ru}
end

begin
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
rescue LoadError
  task :jasmine do
    abort "Jasmine is not available. In order to run jasmine, you must: (sudo) gem install jasmine"
  end
end
