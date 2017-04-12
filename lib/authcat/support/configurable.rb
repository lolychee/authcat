require "active_support/ordered_options"

module Authcat
  module Support
    module Configurable
      extend ActiveSupport::Concern

      class Configuration < ActiveSupport::InheritableOptions
        def initialize(parent = nil)
          @parent = parent
          super
        end

        def has_key?(key)
          super || (@parent && @parent.has_key?(key))
        end

        def convert_key(key)
          key
        end
      end

      module ClassMethods
        def config
          @config ||= if respond_to?(:superclass) && superclass.respond_to?(:config)
            superclass.config.inheritable_copy
          else
            Configuration.new
          end
        end

        def configure(**options)
          config.merge!(options)
          yield config if block_given?

          self
        end

        OPTION_ATTRIBUTES_MODULE = "OptionAttributes"

        def option(name, value = nil, required: false, accessor: true, reader: true, writer: true, class_accessor: true, class_reader: true, class_writer: true, &block)
          if class_accessor
            define_singleton_method("#{name}") do
              config[name]
            end if class_reader

            define_singleton_method("#{name}=") do |value|
              config[name] = value
            end if class_writer
          end

          const_set(OPTION_ATTRIBUTES_MODULE, Module.new) unless const_defined?(OPTION_ATTRIBUTES_MODULE)
          mod = const_get(OPTION_ATTRIBUTES_MODULE)

          if accessor
            if block_given?
              mod.send(:define_method, "#{name}") do
                config[name] ||= instance_exec(self, &block)
              end
            else
              mod.send(:define_method, "#{name}") do
                config[name] || (raise ArgumentError, "option: :#{name} is required" if required)
              end
            end if reader

            mod.send(:define_method, "#{name}=") do |value|
              config[name] = value
            end if writer
          end

          include mod

          config[name] = value
        end
      end

      def config
        @config ||= self.class.config.inheritable_copy
      end
    end
  end
end
