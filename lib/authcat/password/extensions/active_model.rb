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
              algorithm.new(value) rescue nil
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
