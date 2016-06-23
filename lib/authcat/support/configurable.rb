require 'active_support/ordered_options'

module Authcat
  module Support
    module Configurable
      extend ActiveSupport::Concern

      class Configuration < ActiveSupport::InheritableOptions; end

      module ClassMethods

        def config
          @config ||= if respond_to?(:superclass) && superclass.respond_to?(:config)
            superclass.config.inheritable_copy
          else
            Configuration.new
          end
        end

        def configure(**options)
          if block_given?
            yield config
          else
            config.merge!(options)
          end
        end

        def option(name, value = nil, **options, &block)
          config[name] = value

          unless options[:accessor] == false
            if block_given?
              define_method("#{name}") do
                config.fetch(name) { instance_exec(self, &block) }
              end
            else
              define_method("#{name}") do
                config[name]
              end
            end unless options[:reader] == false

            define_method("#{name}=") do |value|
              config[name] = value
            end unless options[:writer] == false
          end
        end

      end

      def config
        @config ||= self.class.config.inheritable_copy
      end
    end
  end
end
