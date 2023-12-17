# frozen_string_literal: true

module Authcat
  module Password
    module Association
      class Attribute < Authcat::Credential::Association::Attribute
        def type_class
          Password::Type.resolve(@type || :digest_password)
        end

        def type_options
          options
        end

        def create(value)
          owner.type_for_attribute(name).cast(Algorithm::Plaintext.new(value.to_s))
        end

        def setup_instance_methods!
          owner.class_eval <<-RUBY, __FILE__, __LINE__ + 1
            # frozen_string_literal: true

            def #{name}=(value)
                super(self.class.passwords[:#{name}].create(value))
            end
          RUBY
        end
      end
    end
  end
end
