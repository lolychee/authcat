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
        def identifiers
          @identifiers ||= Hash.new {|_, key| raise ArgumentError, "Unknown identifier: #{key.inspect}" }
        end

        def identifier(attribute, **opts, &block)
          block ||= -> (value) { find_by(attribute => value) }
          identifiers[attribute] = opts.merge(finder: block)
        end

        def find_by_identifier(attributes = {}, &block)
          finders = if attributes.is_a?(Hash)
            attributes.map { |attribute, id| [identifiers[attribute], value] }
          else
            identifiers.map { |attribute, opts| [opts, attributes] }
          end

          finders.each do |opts, value|
            next unless opts[:format] =~ value.to_s
            found = self.instance_exec(value, &opts[:finder])
            return found if found
          end
          new.tap(&block) if block_given?
        end
      end
    end
  end
end
