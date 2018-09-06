module Authcat
  module Model
    module SecurePassword
      extend ActiveSupport::Concern

      module ClassMethods
        def has_secure_password(attribute = :password, column_name: "#{attribute}_digest", **options, &block)
          attribute column_name, :password, **options

          class_eval <<-METHOD
            attr_reader :#{attribute}

            def #{attribute}=(value)
              self.#{column_name} = ::Authcat::Password::Plaintext.new(value)
              @#{attribute} = value
            end

            def #{attribute}_verify(hashed_password)
              #{column_name}.verify(hashed_password)
            end
          METHOD
        end
      end
    end
  end
end

begin
  require "active_record/type"
rescue LoadError
else

  module ActiveRecord
    module Type
      class Password < String
        attr_reader :algorithm

        def initialize(algorithm: :bcrypt, **options)
          @algorithm = ::Authcat::Password.lookup(algorithm)
          @options = options
        end

        def type
          :password
        end

        def options
          @options ||= {}
        end

        def cast_value(value)
          case value
          when ::Authcat::Password::Plaintext
            algorithm.new(**options) { value }
          when String
            algorithm.new(value, **options)
          else
            serialize(value)
          end
        end

        def serialize(value)
            algorithm.valid?(value, **options) ? value.to_str : nil
        end

        def deserialize(value)
          return if value.nil?
          algorithm.new(value, **options)
        end
      end
    end
  end

  ActiveRecord::Type.register(:password, ActiveRecord::Type::Password)
end
