# frozen_string_literal: true

module Authcat
  module Model
    module SecurePassword
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

      def self.included(base)
        base.extend ClassMethods
      end
    end
  end
end