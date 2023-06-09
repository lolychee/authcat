# frozen_string_literal: true

module Authcat
  module Identifier
    module Association
      class Attribute < Authcat::Credential::Association::Attribute
        def initialize(owner, name, **options, &block)
          super
          @type_klass = Identifier::Type.resolve(@type || :identifier)
          @type_options = options
        end

        def identify(value)
          if @block
            @block.call(value)
          else
            owner.find_by(name => value)
          end
        end

        def setup_instance_methods!; end
      end
    end
  end
end
