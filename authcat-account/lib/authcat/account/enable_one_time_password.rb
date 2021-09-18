# frozen_string_literal: true

module Authcat
  module Account
    class EnableOneTimePassword < Module
      class << self
        alias [] new
      end

      def initialize(attribute = :one_time_password, action_name: :"enable_#{attribute}", recovery_codes_attribute: :recovery_codes)
        super()

        step = :"#{action_name}_step"
        attempt = :"#{attribute}_attempt"

        define_singleton_method(:included) do |base|
          if base < ActiveRecord::Base
            gem "state_machines-activerecord"
            require "state_machines-activerecord"
          end

          base.define_model_callbacks action_name

          base.attr_writer step
          base.class_eval <<~METHOD, __FILE__, __LINE__ + 1
            def #{step}
              return @#{step} if defined?(@#{step})
              @#{step} = self.class.state_machines[#{step.inspect}].initial_state(self).value
            end
          METHOD
          base.attr_accessor attempt, "#{recovery_codes_attribute}_plaintext"

          intro_name = :"#{action_name}_intro"
          recovery_codes_name = :"#{action_name}_recovery_codes"
          verify_name = :"#{action_name}_verify"

          base.state_machine step, namespace: action_name, initial: :intro, action: nil do
            after_transition from: :intro, to: :recovery_codes, do: lambda { |record|
                                                                      record.send("#{recovery_codes_attribute}_plaintext=", record.send("regenerate_#{recovery_codes_attribute}"))
                                                                    }
            after_transition from: :recovery_codes, to: :verify, do: :"regenerate_#{attribute}"

            event :next do
              transition intro: :recovery_codes
              transition recovery_codes: :verify, if: ->(record) { record.valid?(recovery_codes_name) }
              transition verify: :completed, if: ->(record) { record.valid?(verify_name) }
              transition any => same
            end
          end

          base.validates recovery_codes_attribute, presence: true, on: [recovery_codes_name, verify_name]
          base.validates attribute, presence: true, on: verify_name
          base.validates attempt, verify: attribute, on: verify_name
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
            slice(step, attribute, recovery_codes_attribute)
          end
        end

        define_method("disable_#{attribute}!") do
          update!(attribute => nil, recovery_codes_attribute => nil)
        end
      end
    end
  end
end
