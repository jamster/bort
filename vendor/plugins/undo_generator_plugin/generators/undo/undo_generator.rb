# Piggy backs on top of the script/destroy command
# to undo the last item in the generator history log.
class UndoGenerator < Rails::Generator::Base

   
   def initialize(runtime_args, runtime_options = {})
      @undo_args = runtime_args
      super
      unless File.exists?(GENERATOR_LOG_FILE)
         puts "Noting to undo" unless options[:quiet] 
         return
      end
      
      require 'rails_generator/scripts/destroy'
      file = open(GENERATOR_LOG_FILE,'r+')
      lines = file.read.split("\n")
      if (line = lines.pop) !~ /^\#/
         input = ''
         while input !~ /n/i
            print "Undo: \"script/generate #{line}\"  [yn]? " unless options[:quiet] 
            input = options[:collision] == :force ?  'y' : gets
            if  input =~ /y/i
            Rails::Generator::Scripts::Destroy.new.run(line.split(/\s/))

            # remove the log entry for the un-done command
            file.pos = 0
            file.print lines.join("\n") + "\n"
            file.truncate(file.pos)
            return
           end
         end


      end

   end

   # Since is undo'ing a previous action don't bother with
   # a manifest. Leave as empty
   def manifest
      record do |m|
      end
   end

   def file_name
      "undo"
   end

end
