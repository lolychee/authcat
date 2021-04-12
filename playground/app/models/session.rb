class Session < ApplicationRecord
  include Authcat::Identity::Validators
  include Authcat::Password::Validators
  include Authcat::MultiFactor

  belongs_to :user, optional: true
  validates :user, presence: true, on: :save

  concerning :SignIn do
    included do
      define_model_callbacks :sign_in
      delegate :password, :verify_one_time_password, :verify_backup_codes, to: :user, allow_nil: true

      attribute :step, :string, default: "authentication"
      attribute :auth_type, :string, default: "password"
      attribute :submit, :string
      attribute :login, :string
      attribute :email, :string
      attribute :phone_number, :string
      attribute :remember_me, :boolean

      attribute :password_attempt, :string
      attribute :one_time_password_attempt, :string
      attribute :recovery_code_attempt, :string

      state_machine :step, initial: :authentication, action: nil do
        before_transition from: :authentication, except_to: :authentication do |record, transition|
          record.valid?(:authenticate)
        end
        before_transition from: :authentication, to: :two_factor_authentication do |record, transition|
          record.user&.one_time_password?
        end
        before_transition from: :authentication, to: :completed do |record, transition|
          !record.user&.one_time_password?
        end
        before_transition from: :two_factor_authentication, to: :completed do |record, transition|
          record.valid?(:two_factor_authenticate)
        end

        after_transition from: :authentication, to: :two_factor_authentication do |record, transition|
          record.auth_type = 'one_time_password'
        end

        event :next do
          transition authentication: :two_factor_authentication
          transition authentication: :completed
          transition two_factor_authentication: :completed
          transition any => same
        end
        event :stay do
          transition any => same
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
        self.stay
      end

      self.completed? && run_callbacks(:sign_in) { save }
    end
  end
end
