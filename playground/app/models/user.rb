# frozen_string_literal: true

class User < ApplicationRecord
  include Authcat::Account

  has_many :sessions, dependent: :delete_all

  ENV["LOCKBOX_MASTER_KEY"] = "0000000000000000000000000000000000000000000000000000000000000000"

  identifier :email, type: :email
  identifier :phone_number, type: :phone_number
  # identifier :github_oauth_token, type: :token
  # identifier :google_oauth_token, type: :token

  has_password
  has_one_time_password
  has_one_time_password :recovery_codes, algorithm: :bcrypt, array: true, burn_after_verify: true

  concerning :SignUp do
    included do
      define_model_callbacks :sign_up
    end

    def sign_up(attributes = {}, &block)
      with_transaction_returning_status do
        assign_attributes(attributes)
        valid?(:sign_up) && run_callbacks(:sign_up) { _sign_up(&block) }
      end
    end

    def _sign_up(**)
      save
    end
  end

  concerning :UpdateProfile do
    included do
      define_model_callbacks :update_profile
    end

    def update_profile(attributes = {}, &block)
      with_transaction_returning_status do
        assign_attributes(attributes)
        valid?(:update_profile) && run_callbacks(:update_profile) { _update_profile(&block) }
      end
    end

    def _update_profile(**)
      save
    end
  end

  include Authcat::Account::ChangePassword[:password]
  include Authcat::Account::EnableOneTimePassword[:one_time_password]
end
