# frozen_string_literal: true

module Authcat
  module Password
    module Association
      class Attribute < Authcat::Credential::Association::Attribute
        def initialize(owner, name, options)
          as = options.delete(:as) || :digest
          super
          @type_klass = Password::Type.resolve(as)
          @type_options = options
        end

        def create(value)
          owner.type_for_attribute(name).encoder.parse(Algorithm::Plaintext.new(value.to_s))
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

        def setup_instance_methods!
          owner.class_eval <<-CODE, __FILE__, __LINE__ + 1
            # frozen_string_literal: true

            def #{name}=(value)
              if value.respond_to?(:to_s)
                super(Algorithm::Plaintext.new(value.to_s))
              end
            end
          CODE
        end
      end
    end
  end
end
