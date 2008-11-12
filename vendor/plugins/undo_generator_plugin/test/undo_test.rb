require File.join(File.dirname(__FILE__), 'test_helper')

# Note - at the moment the tests for the undo procedure only 
# check that the line has been removed from the log not that
# the destroy command has been carried out. 
class UndoTest < Test::Unit::TestCase


   def setup
      @history_log_file =  File.join(RAILS_ROOT, 'log', "generator.log")
      File.delete(@history_log_file) if File.exists?(@history_log_file) # clear the history for each test
   end
   
   def test_should_add_line_to_history_on_generate
      single_model_generate
      assert_equal @params.join(' '), File.open(@history_log_file).collect.last.chomp
   end
   
   def test_should_add_multiple_lines_to_history_on_generate
      multiple_model_generate
      check_multi
   end
   
   def test_should_work_with_different_generators
      different_generators
      check_multi
   end


   

   def test_should_undo_correctly_for_single_generator
      single_model_generate('dog')
      assert_equal @params.join(' '), File.open(@history_log_file).collect.last.chomp
      Rails::Generator::Scripts::Generate.new.run( %w'undo -f') 
      assert_equal 0, number_of_history_lines
   end

   def test_should_undo_correctly_for_multiple
      multiple_model_generate
      assert_equal 3, number_of_history_lines
      Rails::Generator::Scripts::Generate.new.run( %w'undo -f') 
      assert_equal 2, number_of_history_lines
      Rails::Generator::Scripts::Generate.new.run( %w'undo -f') 
      assert_equal 1, number_of_history_lines
      Rails::Generator::Scripts::Generate.new.run( %w'undo -f') 
      assert_equal 0, number_of_history_lines      
   end

   
   def test_should_undo_complex
      multiple_model_generate
      assert_equal 3, number_of_history_lines
      Rails::Generator::Scripts::Generate.new.run( %w'undo -f') 
      assert_equal 2, number_of_history_lines
      single_model_generate
      assert_equal 3, number_of_history_lines
      single_model_generate
      assert_equal 4, number_of_history_lines
      Rails::Generator::Scripts::Generate.new.run( %w'undo -f') 
      Rails::Generator::Scripts::Generate.new.run( %w'undo -f') 
      assert_equal 2, number_of_history_lines
   end
   
   ## stubs 

   # def test_should_do_nothing_if_no_undo_history_log
   #    Rails::Generator::Scripts::Generate.new.run(['undo'])
   # end

   # def test_should_do_nothing_if_no_undo_history_log
   #    Rails::Generator::Scripts::Generate.new.run(['undo'])
   # end
   
   # def test_should_not_log_if_no_generator
   #    @params = []
   #    Rails::Generator::Scripts::Generate.new.run(@params.clone)
   #    assert_equal 0, number_of_history_lines
   # end

end
