module Authcat
  class Options < ActiveSupport::OrderedOptions

    module Optionable
      extend ActiveSupport::Concern

      module ClassMethods

        def default_options
          @default_options ||= Authcat::Options.new
        end

        def option(name, value = nil, **options, &block)
          define_option_reader(name) if options[:accessor] || options[:reader]
          define_option_writer(name) if options[:accessor] || options[:writer]

          default_options[name] = block_given? ? block : value
        end

        def define_option_reader(name)
          class_eval <<-METHOD
            def #{name}
              options[:#{name}]
            end
          METHOD
        end

        def define_option_writer(name)
          class_eval <<-METHOD
            def #{name}=(value)
              options[:#{name}] = value
            end
          METHOD
        end

        def configure(**options)
          if block_given?
            yield default_options
          else
            default_options.merge!(options)
          end
        end

      end

      def apply_options(opts)
        options.merge!(opts)
      end

      private

        def options
          @options ||= Authcat::Options.new do |options, key|
            value = self.class.default_options[key]
            options[key] = value.respond_to?(:call) ? value.call(self) : value
          end
        end

    end
  end
end
