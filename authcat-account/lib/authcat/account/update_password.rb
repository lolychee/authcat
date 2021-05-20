# frozen_string_literal: true

module Authcat
  module Account
    class UpdatePassword < Module
      class << self
        alias [] new
      end

      def initialize(attribute, action_name: :"update_#{attribute}")
        super()
        old_password = :"old_#{attribute}"
        new_password = :"new_#{attribute}"

        define_singleton_method(:included) do |base|
          base.define_model_callbacks action_name

          base.attr_accessor old_password, new_password

          base.validates attribute, verify: attribute, on: action_name, if: attribute
          base.validates new_password, presence: true, on: action_name, confirmation: true
        end

        define_method(action_name) do |attrs = {}|
          self.attributes = attrs
          valid?(action_name) && run_callbacks(action_name) do
            update(attribute => send(new_password))
          end
        end
      end
    end
  end
end
