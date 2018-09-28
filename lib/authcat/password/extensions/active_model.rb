# frozen_string_literal: true

module Authcat
  module Password
    module Extensions
      module ActiveModelExtension
        if defined?(ActiveModel) && defined?(ActiveModel::Type)
          class PasswordType < ActiveModel::Type::String
            attr_reader :algorithm, :options

            def initialize(algorithm:, **opts)
              @algorithm = ::Authcat::Password.new(algorithm, **opts)
            end

            def type
              :password
            end

            def cast_value(value)
              case value
              when ::Authcat::Password::Algorithms::Plaintext
                algorithm.new.update(value)
              else
                value_str = value.to_s
                algorithm.valid?(value_str) ? algorithm.new(value_str) : nil
              end
            end

            def serialize(value)
              value_str = value.to_s
              algorithm.valid?(value_str) ? value_str : nil
            end
          end

          ActiveModel::Type.register(:password, PasswordType)
        end
      end
    end
  end
end
