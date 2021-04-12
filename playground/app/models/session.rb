class Session < ApplicationRecord
  include Authcat::Identity::Validators
  include Authcat::Password::Validators
  include Authcat::MultiFactor
  include AASM

  belongs_to :user, optional: true
  validates :user, presence: true, on: :save

  concerning :SignIn do
    included do
      define_model_callbacks :sign_in
      delegate :password, :verify_one_time_password, :verify_backup_codes, to: :user, allow_nil: true

      attribute :step, :string
      attribute :auth_type, :string, default: "password"
      attribute :submit, :string
      attribute :login, :string
      attribute :email, :string
      attribute :phone_number, :string
      attribute :remember_me, :boolean

      attribute :password_attempt, :string
      attribute :one_time_password_attempt, :string
      attribute :recovery_code_attempt, :string

      aasm(:step, enum: false) do
        state :authentication, initial: true
        state :two_factor_authentication
        state :completed

        event :next do
          transitions from: :authentication, to: :two_factor_authentication do
            guard do
              valid?(:authenticate) && user&.one_time_password?
            end
            after do
              self.auth_type = "one_time_password"
            end
          end
          transitions from: :authentication, to: :completed do
            guard do
              valid?(:authenticate) && !user&.one_time_password?
            end
          end
          transitions from: :two_factor_authentication, to: :completed do
            guard do
              valid?(:two_factor_authenticate)
            end
          end
        end
      end

      with_options on: :authenticate do
        validates :email, identify: :user, if: :email?

        validates :user, presence: true

        validates :password_attempt, authenticate: :password, if: -> { auth_type == "password" && user }
      end
      with_options on: :two_factor_authenticate do
        validates :user, presence: true

        validates :one_time_password_attempt, authenticate: :one_time_password, if: -> { auth_type == "one_time_password" && user }
        validates :recovery_code_attempt, authenticate: :backup_codes, if: -> { auth_type == "recovery_code" && user }
      end
    end

    def sign_in(attributes = {})
      self.attributes = attributes
      case self.submit
      when nil, "next"
        self.next
      when "stay"
        nil # do nothing
      end

      self.completed? && run_callbacks(:sign_in) { save }
    rescue AASM::InvalidTransition => e
      false
    end
  end
end
