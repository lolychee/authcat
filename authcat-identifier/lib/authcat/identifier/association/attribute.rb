# frozen_string_literal: true

module Authcat
  module Identifier
    module Association
      class Attribute < Authcat::Credential::Association::Attribute
        def initialize(owner, name, options)
          as = options.delete(:as) || :identifier
          super
          @type_klass = Identifier::Type.resolve(as)
          @type_options = options
        end

        def identify(value)
          owner.find_by(name => value)
        end

        def setup!
          setup_attribute!
          setup_instance_methods!
        end

        def setup_attribute!
          owner.attribute name do |cast_type|
            @type_klass.new(cast_type, **@type_options)
          end
        end

        def setup_instance_methods!; end
      end
    end
  end
end