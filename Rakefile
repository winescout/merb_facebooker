# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

begin
  require 'bones'
  Bones.setup
rescue LoadError
  begin
    load 'tasks/setup.rb'
  rescue LoadError
    raise RuntimeError, '### please install the "bones" gem ###'
  end
end

ensure_in_path 'lib'
require 'merb-facebooker'

task :default => 'spec:run'

PROJ.name = 'merb-facebooker'
PROJ.authors = 'Matt Clark'
PROJ.email = 'merb-facebooker@alwaysforward.com'
PROJ.url = 'www.alwaysforward.com'
PROJ.version = MerbFacebooker::VERSION
PROJ.rubyforge.name = 'merb-facebooker'

PROJ.spec.opts << '--color'

# EOF
