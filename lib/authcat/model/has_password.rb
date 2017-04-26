module Authcat
  module Model
    module HasPassword
      extend ActiveSupport::Concern

      module ClassMethods
        def has_password(attribute = :password, column_name: "#{attribute}_digest", **options, &block)
          attribute column_name, :password, **options

          class_eval <<-RUBY
            attr_reader :#{attribute}

            def #{attribute}=(value)
              self.#{column_name} = ::Authcat::Password::Raw.new(value)
              @#{attribute} = value
            end
          RUBY
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
        def initialize(**options)
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
          when ::Authcat::Password::Raw
            ::Authcat::Password.create(value, **options)
          when String
            ::Authcat::Password.parse(value, **options)
          else
            ::Authcat::Password.valid?(value, **options) ? value : nil
          end
        end

        def serialize(value)
          if ::Authcat::Password.valid?(value, **options)
            value.to_str
          else
            nil
          end
        end

        def deserialize(value)
          return if value.nil?
          ::Authcat::Password.parse(value, **options)
        end
      end
    end
  end

  ActiveRecord::Type.register(:password, ActiveRecord::Type::Password)
end
