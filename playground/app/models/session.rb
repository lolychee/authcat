class Session < ApplicationRecord
  include Authcat::Identity::Validators
  include Authcat::Password::Validators
  include Authcat::MultiFactor

  belongs_to :user, optional: true
  validates :user, presence: true, on: :save

  concerning :SignIn do
    included do
      define_model_callbacks :sign_in
      delegate :password, :verify_password, :one_time_password, :verify_one_time_password, :backup_codes, :verify_backup_codes, to: :user, allow_nil: true

      attribute :step, :string, default: "authentication"
      attribute :auth_type, :string, default: "password"
      attribute :submit, :string
      attribute :login, :string
      attribute :email, :string
      attribute :phone_number, :string
      attribute :remember_me, :boolean

      state_machine :step, initial: :authentication, action: nil do
        before_transition from: :authentication, except_to: :authentication do |record, transition|
          record.valid?(:authenticate)
        end
        before_transition from: :authentication, to: :two_factor_authentication do |record, transition|
          record.two_factor_authentication_required?
        end
        before_transition from: :authentication, to: :completed do |record, transition|
          !record.two_factor_authentication_required?
        end
        before_transition from: :two_factor_authentication, to: :completed do |record, transition|
          record.valid?(:two_factor_authenticate)
        end

        after_transition from: :authentication, to: :two_factor_authentication do |record, transition|
          record.auth_type = record.primary_two_factor
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
        # validate :check_user_status, if: :user

        validates :password, attempt: true, if: -> { auth_type == "password" && user }
      end
      with_options on: :two_factor_authenticate do
        validates :user, presence: true

        validates :one_time_password, attempt: true, if: -> { auth_type == "one_time_password" && user }
        validates :recovery_code, attempt: true, if: -> { auth_type == "recovery_code" && user }
      end
    end

    def check_user_status
      if user.locked?
        errors.add(:user, :locked)
      elsif user.blocked?
        errors.add(:user, :blocked)
      end
    end

    # after_sign_in do
    #   if user.reset_password_token.present?
    #     user.attributes = { reset_password_token: nil, reset_password_sent_at: nil }
    #   end

    #   if user.deactivated?
    #     user.activate = true
    #   end

    #   user.save
    # end

    def two_factor_authentication_required?
      user&.one_time_password?
    end

    def primary_two_factor
      'one_time_password'
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
