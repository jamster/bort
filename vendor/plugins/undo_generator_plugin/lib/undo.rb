module BeyondTheType
   module Undo


      def run(args = [], runtime_options = {})
         # Intercept all calls to run the generator by logging it first
         unless args[0] =~ /undo/i   ||  args.empty?
            logger = Logger.new(GENERATOR_LOG_FILE)
            logger.level = Logger::INFO
            logger.info(args.join(' '))
         end
         # The log call runs first  because even if it doesn't complete fully we still want to try
         # to be able to undo it
         super(args, runtime_options)
      end
   end

end
