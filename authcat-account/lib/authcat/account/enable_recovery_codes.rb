# frozen_string_literal: true

module Authcat
  module Account
    class EnableRecoveryCodes < Module
      class << self
        alias [] new
      end

      def initialize(attribute = :recovery_codes, action_name: :"enable_#{attribute}")
        super()

        define_singleton_method(:included) do |base|
          base.define_model_callbacks action_name

          # base.validates attribute, presence: true, on: action_name
        end

        define_method(action_name) do |attributes = {}|
          assign_attributes(attributes)
          valid?(action_name) && run_callbacks(action_name) { save }
        end

        define_method("disable_#{attribute}!") do
          update!(attribute => nil)
        end
      end
    end
  end
end
