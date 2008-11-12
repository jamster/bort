Object.const_set('GENERATOR_LOG_FILE',File.join(RAILS_ROOT, 'log', "generator.log")) # need better way to pass?

require 'rails_generator/base'
require 'rails_generator/scripts/generate'
require 'undo'

class Rails::Generator::Scripts::Generate
  include BeyondTheType::Undo     
end