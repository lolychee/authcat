# frozen_string_literal: true

module Authcat
  module Password
    module Extensions
      module ActiveModelExtension
        if defined?(ActiveModel) && defined?(ActiveModel::Type)
          class PasswordType < ActiveModel::Type::Value
            attr_reader :algorithm, :options

            def initialize(algorithm:, **opts)
              @algorithm = ::Authcat::Password.new(algorithm, **opts)
            end

            def type
              :password
            end

            def cast_value(value)
              algorithm.new(value)
            rescue
              nil
            end

            def serialize(value)
              value_str = value.to_s
              algorithm.valid?(value_str) ? value_str : nil
            rescue
              nil
            end

            def deserialize(value)
              super
            end

            def changed_in_place?(raw_old_value, new_value)
              deserialize(raw_old_value) != new_value
            end
          end

          class PasswordSupportArrayType < PasswordType
            def initialize(algorithm:, **opts)
              @array = opts.delete(:array)
              super
            end

            def cast_value(value)
              if @array
                case value
                when String
                  ActiveSupport::JSON.decode(value).map {|pwd| super(pwd) } rescue nil
                when Array
                  value.map {|pwd| super(pwd) }
                else
                  nil
                end
              else
                super
              end
            rescue
              nil
            end

            def serialize(value)
              if @array
                ActiveSupport::JSON.encode(value.map {|pwd| super(pwd) }) if value.is_a?(Array)
              else
                super
              end
            rescue
              nil
            end
          end

          ActiveModel::Type.register(:password, PasswordSupportArrayType)
        end
      end
    end
  end
end
