module Authcat
  module Session
    module Authenticatable
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        attr_reader :authentication

        def authenticatable(...)
          @authentication = Authentication.new(...)
        end
      end

      class Authentication
        def initialize(model)
          @model = model

          yield if block_given?
        end

        def factors(*attributes, **opts)
          attributes.each do |attribute|
            factor attribute, **opts
          end
        end
      end
    end
  end
end
