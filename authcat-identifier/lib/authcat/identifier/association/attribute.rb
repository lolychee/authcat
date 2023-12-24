# frozen_string_literal: true

module Authcat
  module Identifier
    module Association
      class Attribute < Authcat::Credential::Association::Attribute
        def type_class
          Identifier::Type.resolve(@type || :identifier)
        end

        def type_options
          options
        end

        def identify(value)
          if @block
            @block.call(value)
          else
            owner.find_by(name => value)
          end
        end
      end
    end
  end
end
