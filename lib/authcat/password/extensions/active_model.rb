# frozen_string_literal: true

module Authcat
  module Password
    module Extensions
      module ActiveModelExtension
        if defined?(ActiveModel) && defined?(ActiveModel::Type)
          class PasswordType < ActiveModel::Type::String
            attr_reader :algorithm, :options

            def initialize(**opts)
              @algorithm = ::Authcat::Password::Algorithms.lookup(opts.fetch(:algorithm, ::Authcat::Password.default_algorithm))
              @options = opts
              super
            end

            def type
              :password
            end

            def cast_value(value)
              case value
              when ::Authcat::Password::Algorithms::Plaintext
                algorithm.new(**options) { value }.to_s
              else
                value_str = value.to_s
                algorithm.valid?(value_str, **options) ? algorithm.new(value_str, **options) : nil
              end
            end

            def serialize(value)
              value_str = value.to_s
              algorithm.valid?(value_str, **options) ? value_str : nil
            end
          end

          ActiveModel::Type.register(:password, PasswordType)
        end
      end
    end
  end
end
