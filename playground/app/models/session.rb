class Session < ApplicationRecord
  include Authcat::Identifier::Validators
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
      attribute :submit, :boolean, default: true
      attribute :login, :string
      attribute :email, :string
      attribute :phone_number, :string
      attribute :remember_me, :boolean

      state_machine :step, initial: :authentication, action: nil do
        after_transition authentication: :two_factor_authentication do |record, transition|
          record.auth_type = record.primary_two_factor
        end

        event :next do
          transition two_factor_authentication: :completed, if: -> (record) { record.valid?(:two_factor_authenticate) }
          transition authentication: :two_factor_authentication, if: -> (record) { record.valid?(:authenticate) && record.two_factor_authentication_required? }
          transition authentication: :completed, if: -> (record) { record.valid?(:authenticate) && !record.two_factor_authentication_required? }
          transition any => same
        end
      end

      with_options on: :authenticate do
        validates :email, identify: :user, if: :email?

        validates :user, presence: true
        # validate :validate_user_status, if: :user

        validates :password, attempt: true, if: -> { auth_type == "password" && user }
      end
      with_options on: :two_factor_authenticate do
        validates :user, presence: true

        validates :one_time_password, attempt: true, if: -> { auth_type == "one_time_password" && user }
        validates :recovery_code, attempt: true, if: -> { auth_type == "recovery_code" && user }
      end
    end

    def validate_user_status
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

    def recovery_code
      nil
    end

    def verify_recovery_code(code)
      @user&.verify_backup_codes(code)
    end

    def sign_in(attributes = {})
      self.attributes = attributes
      self.next if self.submit

      self.completed? && run_callbacks(:sign_in) { save }
    end
  end

  concerning :OmniAuth do
    class_methods do
      def find_or_create_from_auth_hash(auth_hash)
        user = case auth_hash.provider
        when "developer"
          User.find_or_create_by(email: auth_hash.uid)
        when "github"
          User.find_or_create_by(github_oauth_token: auth_hash.uid) do |u|
            u.name = auth_hash.info.nickname
          end
        else
          nil
        end
        create(user: user) if user
      end
    end
  end
end
