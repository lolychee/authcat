class Session < ApplicationRecord
  include Authcat::Identity::Validators
  include Authcat::Password::Validators
  include Authcat::MultiFactor

  belongs_to :user, optional: true
  validates :user, presence: true, on: :save

  concerning :SignIn do
    included do
      define_model_callbacks :sign_in
      # delegate :password, :one_time_password, to: :user, prefix: true, allow_nil: true

      # attribute :id_type, :string, default: :user_token
      # attribute :auth_type, :string, default: :one_time_password
      # attribute :email, :string
      # attribute :user_token, :string
      # attribute :remember_me, :boolean

      # with_options on: :sign_in do
      #   validates :auth_type, inclusion: { in: %w[password one_time_password] }
      #   validates :id_type, inclusion: { in: %w[login email phone_number] }, if: -> { auth_type == "password" }
      #   validates :id_type, inclusion: { in: %w[user_token] }, if: -> { auth_type == "one_time_password" }

      #   validates :email, identify: :user, if: -> { id_type == "email" }
      #   validates :password, authenticate: :user_password, if: -> { auth_type == "password" && user }

      #   validates :user_token, identify: :user, if: -> { id_type == "user_token" }
      #   validates :one_time_password, authenticate: :user_one_time_password, if: -> { auth_type == "one_time_password" }
      # end
    end

    def sign_in
      user_authenticate && valid?(:sign_in) && run_callbacks(:sign_in) do
        save
      end
    end

  end

  attribute :email, :string
  attribute :tsv_token, :string
  attribute :remember_me, :boolean

  multi_factor_authentication :user, default: %w[email password] do
    factor :password,           identifier: %i[email phone_number login]
    factor :verification_code,  identifier: %i[email phone_number]
    factor :one_time_password,  identifier: %i[tsv_token]
    factor :webauthn,           identifier: %i[tsv_token]

    # identifier_factor :cross_login_token
  end

end
