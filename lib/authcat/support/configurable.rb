require 'active_support/ordered_options'

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

        CONFIG_ATTRIBUTES_MODULE = 'ConfigAttributes'

        def option(name, value = nil, **options, &block)

          unless options[:class_accessor] == false
            define_singleton_method("#{name}") do
              config[name]
            end unless options[:class_reader] == false

            define_singleton_method("#{name}=") do |value|
              config[name] = value
            end unless options[:class_writer] == false
          end

          const_set(CONFIG_ATTRIBUTES_MODULE, Module.new) unless const_defined?(CONFIG_ATTRIBUTES_MODULE)
          mod = const_get(CONFIG_ATTRIBUTES_MODULE)

          unless options[:accessor] == false
            if block_given?
              mod.send(:define_method, "#{name}") do
                config[name] ||= instance_exec(self, &block)
              end
            else
              mod.send(:define_method, "#{name}") do
                config[name] || (raise ArgumentError, "option: :#{name} is required" if options[:require])
              end
            end unless options[:reader] == false

            mod.send(:define_method, "#{name}=") do |value|
              config[name] = value
            end unless options[:writer] == false
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
