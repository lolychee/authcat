# frozen_string_literal: true

module Authcat
  module Account
    class EnableOneTimePassword < Module
      class << self
        alias [] new
      end

      def initialize(attribute = :one_time_password, action_name: :"enable_#{attribute}",
                     recovery_codes_attribute: :recovery_codes)
        super()

        step = :"#{action_name}_step"

        define_singleton_method(:included) do |base|
          if base < ActiveRecord::Base
            gem "state_machines"
            require "state_machines"
          end

          base.define_model_callbacks action_name

          intro_step = :"#{action_name}_intro"
          recovery_codes_step = :"#{action_name}_recovery_codes"
          verify_step = :"#{action_name}_verify"

          base.validates recovery_codes_attribute, presence: true, on: [recovery_codes_step, verify_step]
          base.validates attribute, presence: true, challenge: true, on: verify_step

          base.attr_accessor "#{recovery_codes_attribute}_plaintext"

          base.attribute step, :string, default: :intro
          base.state_machine step, namespace: action_name, initial: :intro, action: nil do
            state :intro do
              transition to: :recovery_codes, on: :submit, if: ->(record) { record.valid?(:intro) }
            end
            after_transition from: :intro, to: :recovery_codes, do: lambda { |record|
                                                                      record.send("#{recovery_codes_attribute}_plaintext=", record.send("regenerate_#{recovery_codes_attribute}"))
                                                                    }

            state :recovery_codes do
              transition to: :verify, on: :submit, if: ->(record) { record.valid?(:recovery_codes) }
            end
            after_transition from: :recovery_codes, to: :verify, do: lambda { |record|
                                                                       record.send("regenerate_#{attribute}")
                                                                     }

            state :verify do
              transition to: :completed, on: :submit, if: ->(record) { record.valid?(:verify) }
            end
            after_transition to: :completed, do: ->(record) { record.run_callbacks(action_name) { record.save } }

            event :submit do
              transition any - [:completed] => same
            end
          end
        end

        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{action_name}(attributes = {})
            assign_attributes(attributes)
            submit_#{action_name}
          end
        RUBY

        define_method("disable_#{attribute}!") do
          update!(attribute => nil, recovery_codes_attribute => nil)
        end
      end
    end
  end
end
