# frozen_string_literal: true

module Authcat
  module Password
    module Association
      class Attribute < Authcat::Credential::Association::Attribute
        def initialize(owner, name, **options, &block)
          super
          @type_klass = Password::Type.resolve(@type || :digest)
          @type_options = options
        end

        def create(value)
          owner.type_for_attribute(name).serialize(Algorithm::Plaintext.new(value.to_s))
        end

        def setup_instance_methods!
          owner.class_eval <<-CODE, __FILE__, __LINE__ + 1
            # frozen_string_literal: true

            def #{name}=(value)
                super(self.class.passwords[:#{name}].create(value))
            end
          CODE
        end
      end
    end
  end
end
