module Authcat
  module Password
    module SecurePassword
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        # @param Attribute [Symbol, String]
        # @param suffix [Symbol, String]
        # @param column_name [Symbol, String]
        # @param validate [Boolean]
        # @return [Symbol]
        def has_password(
          attribute = :password,
          validate: true,
          **opts
        )
          cast_type = Attribute.new(self, attribute, **opts).to_type

          attribute attribute, cast_type

          if validate
            include ActiveModel::Validations

            validates_presence_of attribute

            validates_confirmation_of attribute, allow_nil: true
          end

          _password_singleton_module.module_eval do
            define_method(attribute) do
              type_for_attribute(attribute)&.attribute
            end
          end

          self.password_attributes ||= Set.new
          self.password_attributes |= [attribute.to_s]

          attribute.to_sym
        end
      end

      class Attribute
        attr_reader :kdf

        def initialize(klass, attribute_name, kdf: Password.default_kdf, array: false, **opts)
          @klass = klass
          @attribute_name = attribute_name
          @array = array
          @kdf = KDF.resolve(kdf)
          @opts = opts
        end

        def array?
          @array
        end

        def valid?(ciphertext)
          @kdf.valid?(ciphertext, **@opts)
        end

        def new(ciphertext)
          @kdf.new(ciphertext, **@opts)
        end

        def create(plaintext)
          @kdf.create(plaintext, **@opts)
        end

        def compare(plaintext, ciphertext)
          @kdf.compare(plaintext, ciphertext)
        end

        def to_type
          Type.new(attribute: self)
        end
      end

      class Type < ActiveModel::Type::String
        attr_reader :attribute

        def initialize(**args)
          @attribute = args.fetch(:attribute) { raise ArgumentError, ":attribute is required" }
          extend Array if @attribute.array?
          super(**args.slice(:precision, :scale, :limit))
        end

        def type
          :password
        end

        def cast_value(value)
          if attribute.valid?(value)
            attribute.new(value)
          else
            attribute.create(value)
          end
        end

        module Array
          def serialize(value)
            case value
            when Array
              value.map { |pwd| super(pwd) }.to_json
            end
          end

          def cast_value(value)
            case value
            when Array
              value.map { |pwd| super(pwd) }
            when String
              JSON.parse(value).map { |pwd| super(pwd) }
            end
          end
        end
      end
    end
  end
end
