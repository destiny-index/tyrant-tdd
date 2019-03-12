require 'rake/testtask'

Rake::TestTask.new

task :default => :test

task :test => :server do
  sh "killall ttserver"
end

task :server do
  sh "ttserver -port 1978 > /dev/null &"
end
