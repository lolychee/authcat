# frozen_string_literal: true

module Authcat
  module Account
    class ChangePassword < Module
      class << self
        alias [] new
      end

      def initialize(attribute, action_name: :"change_#{attribute}")
        super()

        define_singleton_method(:included) do |base|
          base.define_model_callbacks action_name

          base.validates attribute, challenge: { was: true }, if: :"#{attribute}?", on: action_name
          base.validates attribute, presence: true, confirmation: true, on: action_name
        end

        define_method(action_name) do |attrs = {}|
          self.attributes = attrs
          valid?(action_name) && run_callbacks(action_name) do
            save
          end
        end
      end
    end
  end
end
