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
      delegate :password, :verify_one_time_password, to: :user, allow_nil: true

      attribute :sign_in_step, :string
      attribute :login, :string
      attribute :email, :string
      attribute :phone_number, :string
      attribute :remember_me, :boolean

      attribute :password_attempt, :string
      attribute :one_time_password_attempt, :string

      aasm(:sign_in_step, enum: false) do
        state :password, initial: true
        state :one_time_password
        state :completed

        event :next do
          transitions from: :password, to: :one_time_password do
            guard do
              valid?(:sign_in) && user&.one_time_password?
            end
          end
          transitions from: :password, to: :completed do
            guard do
              valid?(:sign_in) && !user&.one_time_password?
            end
            after do
              run_callbacks(:sign_in) { save }
            end
          end
          transitions from: :one_time_password, to: :completed do
            guard do
              valid?(:sign_in)
            end
            after do
              run_callbacks(:sign_in) { save }
            end
          end
        end
      end

      with_options on: :sign_in do
        validates :email, identify: :user, if: :email?

        validates :user, presence: true

        validates :password_attempt, authenticate: :password, if: -> { sign_in_step == "password" && user }
        validates :one_time_password_attempt, authenticate: :one_time_password, if: -> { sign_in_step == "one_time_password" && user }
      end
    end

    def sign_in(attributes = {})
      self.attributes = attributes
      self.next && self.completed?
    rescue AASM::InvalidTransition => e
      false
    end
  end

end
