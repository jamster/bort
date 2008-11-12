require 'test/unit'
plugin_test_dir = File.dirname(__FILE__)
require File.join(plugin_test_dir, '../../../../config/environment')
require 'rails_generator'
require 'rails_generator/scripts/generate'


def check_multi
        assert_equal @multi.size, @lines.size
        for i in 0..@multi.size - 1
           assert_equal @multi[i].join(' '), @lines[i].chomp
        end
  end
 
  def single_model_generate(name = 'example')
     @params =  "model #{name} -f".split(' ')
     Rails::Generator::Scripts::Generate.new.run(@params.clone)
  end

  def multiple_model_generate
     @multi = [ %w'model dog -f', %w'model cat -f',  %w'model parrot -f']
     for params in @multi
        Rails::Generator::Scripts::Generate.new.run(params.clone)
     end
     @lines = File.open(@history_log_file).collect
     @lines.shift # remove the header
  end

  def different_generators
      @multi = [%w'scaffold spider -f', %w'controller Article index new -f']
      for params in @multi
         Rails::Generator::Scripts::Generate.new.run(params.clone)
      end
      @lines = File.open(@history_log_file).collect
      @lines.shift # remove the header
end

def number_of_history_lines
      @lines = File.open(@history_log_file).collect
      @lines.shift # remove the header
      @lines.size
end
    