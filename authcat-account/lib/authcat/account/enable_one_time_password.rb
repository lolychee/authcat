# frozen_string_literal: true

module Authcat
  module Account
    class EnableOneTimePassword < Module
      class << self
        alias [] new
      end

      def initialize(attribute = :one_time_password, action_name: :"enable_#{attribute}")
        super()

        define_singleton_method(:included) do |base|
          base.define_model_callbacks action_name

          base.validates attribute, presence: true, on: action_name
        end

        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{action_name}(attributes = {})
            assign_attributes(attributes)
            submit_#{action_name}
          end
        RUBY

        define_method("disable_#{attribute}!") do
          update!(attribute => nil)
        end
      end
    end
  end
end
