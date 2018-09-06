# frozen_string_literal: true

module Authcat
  module Extensions
    module ActiveModelExtension
      if defined?(ActiveModel) && defined?(ActiveModel::Type)
        class PasswordType < ActiveModel::Type::String
          attr_reader :algorithm, :options

          def initialize(algorithm: :bcrypt, **opts)
            @algorithm = ::Authcat::Passwords.lookup(algorithm)
            @options = opts
          end

          def type
            :password
          end

          def cast_value(value)
            case value
            when ::Authcat::Passwords::Plaintext
              algorithm.new(**options) { value }.to_s
            else
              value_str = value.to_s
              algorithm.valid?(value_str, **options) ? value_str : nil
            end
          end

          def serialize(value)
            algorithm.valid?(value, **options) ? algorithm.new(value, **options) : nil
          end
        end

        ActiveModel::Type.register(:password, PasswordType)
      end
    end
  end
end
