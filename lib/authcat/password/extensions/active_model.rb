# frozen_string_literal: true

module Authcat
  module Password
    module Extensions
      module ActiveModelExtension
        if defined?(ActiveModel) && defined?(ActiveModel::Type)
          class PasswordType < ActiveModel::Type::String
            attr_reader :algorithm, :options

            def initialize(algorithm:, **opts)
              @array = opts.delete(:array)
              @algorithm = ::Authcat::Password.new(algorithm, **opts)
            end

            def type
              :password
            end

            def cast_value(value)
              if @array
                case value
                when String
                  JSON.parse(value).map {|pwd| algorithm.new(pwd) }
                when Array
                  value.map {|pwd| algorithm.new(pwd) }
                else
                  nil
                end
              else
                algorithm.new(value)
              end
            rescue
              nil
            end

            def serialize(value)
              if @array
                case value
                when Array
                  value.map(&:to_s).select {|pwd| algorithm.valid?(pwd) }.to_json
                else
                  nil
                end
              else
                value_str = value.to_s
                algorithm.valid?(value_str) ? value_str : nil
              end
            rescue
              nil
            end
          end

          ActiveModel::Type.register(:password, PasswordType)
        end
      end
    end
  end
end
