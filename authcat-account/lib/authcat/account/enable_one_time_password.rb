module Authcat
  module Account
    class EnableOneTimePassword < Module
      class << self
        alias [] new
      end

      def initialize(attribute, action_name: :"enable_#{attribute}", recovery_codes_attribute: :recovery_codes)
        super()

        step = :"#{action_name}_step"
        attempt = :"#{attribute}_attempt"

        define_singleton_method(:included) do |base|
          if base < ActiveRecord::Base
            gem 'state_machines-activerecord'
            require 'state_machines-activerecord'
          end

          base.define_model_callbacks action_name

          base.attr_writer step
          base.class_eval <<~METHOD
            def #{step}
              return @#{step} if defined?(@#{step})
              @#{step} = self.class.state_machines[#{step.inspect}].initial_state(self).value
            end
          METHOD
          base.attr_accessor attempt

          base.state_machine step, namespace: action_name, initial: :intro, action: nil do
            after_transition from: :intro, to: :recovery_codes, do: :"regenerate_#{recovery_codes_attribute}"
            after_transition from: :recovery_codes, to: :verify, do: :"regenerate_#{attribute}"

            event :next do
              transition intro: :recovery_codes
              transition recovery_codes: :verify, if: ->(record) { record.valid?(action_name) }
              transition verify: :completed, if: -> (record) { record.valid?(action_name) }
              transition any => same
            end
          end

          base.validates :recovery_codes_digest, presence: true, on: action_name, unless: -> { send(step) == "intro" }
          base.validates :one_time_password_secret, presence: true, on: action_name, if: -> { send(step) == "verify" }
          base.validates attempt, verify: attribute, on: action_name, if: -> { send(step) == "verify" }
        end

        define_method(action_name) do |attributes = {}|
          self.attributes = attributes
          send("next_#{action_name}")

          send("#{action_name}_completed?") && run_callbacks(action_name) { save }
        end

        define_method("#{action_name}_saved_state") do
          if send("#{action_name}_completed?")
            nil
          else
            as_json(methods: [step, :recovery_codes_digest, :one_time_password_secret])
          end
        end

        define_method("disable_#{attribute}!") do
          update!(one_time_password_secret: nil, one_time_password_last_used_at: nil, recovery_codes_digest: nil)
        end
      end
    end
  end
end
