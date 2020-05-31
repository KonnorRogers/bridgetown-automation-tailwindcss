
module Bridgetown
  module Commands
    class Plugins < Command
      class << self
        def init_with_program(prog)
          plugins_cmd = prog.command(:plugins) do |c|
            c.syntax "plugins <subcommand>"
            c.description "List installed plugins or access plugin content"

            c.option "config", "--config CONFIG_FILE[,CONFIG_FILE2,...]", Array,
                     "Custom configuration file"

            c.action do
              output_supercommand_syntax(c)
            end
          end
        end
      end
    end
  end
end
