class UserSession < ApplicationRecord
  include Authcat::Session::SessionRecord
  include ExtraAction

  belongs_to :user

  enum :state, %i[identified granted revoked]

  # track :ip, :country, :region, :city, :location, :user_agent

  atttibute :identify_type
  %i[email phone].each do |type|
    validates type, identify: true, on: %i[identify verify], if: -> { current_identify_type?(type) }
  end

  atttibute :verify_type
  %i[password one_time_password recovery_codes webauthn_credentials].each do |type|
    validates type, verify: true, on: :verify, if: -> { current_verify_type?(type) }
  end

  state_machine :state, namespace: :sign_in, initial: :identification do
    state :identification do
      transition to: :verification, on: :submit, if: lambda { |record|
                                                       record.valid?(:identify) && record.verification_needed?
                                                     }
      transition to: :granted, on: :submit, if: ->(record) { record.valid?(:identify) && !record.verification_needed? }
    end

    state :verification do
      transition to: :two_step_verification, on: :submit, if: lambda { |record|
                                                                record.valid?(:verify) && record.two_step_verification_needed?
                                                              }
      transition to: :granted, on: :submit, if: lambda { |record|
                                                  record.valid?(:verify) && !record.two_step_verification_needed?
                                                }
    end

    state :two_step_verification do
      transition to: :granted, on: :submit, if: ->(record) { record.valid?(:two_step_verify) }
    end
  end

  extra_action :sign_out, do: :destroy

  extra_action :revoke, do: :destroy
end
