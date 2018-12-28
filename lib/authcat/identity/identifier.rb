module Authcat
  module Identity
    module Identifier
      def self.setup(base)
        base.include self
      end

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def identifier_finder
          @identifier_finder ||= Identifier::Finder.new(self)
        end

        def identifier(attribute, **opts, &block)
          identifier_finder.add(attribute, **opts, &block)
        end

        def find_by_identifier(attributes = {})
          identifier_finder.find(attributes)
        end
      end

      class Finder
        attr_reader :model, :identifiers

        def initialize(model)
          @model = model
          @identifiers ||= Hash.new {|_, name| raise ArgumentError, "Unknown identifier: #{name.inspect}" }
        end

        def add(attribute, **opts, &block)
          opts[:finder] << block if block_given?
          identifiers[attribute] = opts
        end

        def find(attributes = {})
          finders = if attributes.is_a?(Hash)
            attributes.map { |attribute, value| [attribute, identifiers[attribute], value] }
          else
            identifiers.map { |attribute, opts| [attribute, opts, attributes] }
          end

          finders.each do |attribute, opts, value|
            next unless opts[:filter].respond_to?(:call) ? opts[:filter].call(value) : default_filter(opts, value)
            found = opts[:finder].respond_to?(:call) ? self.instance_exec(value, &opts[:finder]) : default_finder(attribute, value)
            return found if found
          end

          nil
        end

        def default_filter(opts, value)
          opts[:format] =~ value.to_s
        end

        def default_finder(attribute, value)
          method_name = "find_by_#{attribute}"
          if respond_to?(method_name)
            model.send(method_name, value)
          else
            model.find_by(attribute => value)
          end
        end
      end
    end
  end
end
