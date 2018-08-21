module Authcat
  module Model
    module Locatable
      extend ActiveSupport::Concern

      included do
        locator :global_id
      end

      module ClassMethods
        def locator(name, **opts)
          klass = Locator.lookup(name)
          @locator = klass.new(**opts)
        end

        def find_by_location(location)
          @locator.find(location)
        end

        def to_location(identity)
          @locator.to_location(identity)
        end
      end

      def to_location
        self.class.to_location(self)
      end
    end
  end
end