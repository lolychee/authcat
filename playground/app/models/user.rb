class User < ApplicationRecord
  include Authcat::Identity
  include Authcat::MultiFactor
  include AASM

  has_many :sessions

  ENV['LOCKBOX_MASTER_KEY'] = '0000000000000000000000000000000000000000000000000000000000000000'

  identifier :email, type: :email#, factors: %i[password verification_code]
  identifier :phone_number, type: :phone_number#, factors: %i[password verification_code]
  # identifier :github_oauth_token, type: :token
  # identifier :google_oauth_token, type: :token

  has_password
  has_one_time_password
  has_backup_codes


  concerning :UpdateAccount do
    included do
      define_model_callbacks :update_account
    end

    def update_account(attributes = {})
      self.attributes = attributes
      valid?(:update_account) && run_callbacks(:update_account) do
        save
      end
    end
  end

  concerning :UpdatePassword do
    included do
      define_model_callbacks :update_password

      attribute :old_password_required, :boolean, default: true
      attribute :old_password, :string
      attribute :new_password, :string

      with_options on: :update_password do
        validates :old_password, presence: true, authenticate: :password, if: :old_password_required
        validates :new_password, presence: true, confirmation: true
      end
    end

    def update_password(attributes = {})
      self.attributes = attributes
      valid?(:update_password) && run_callbacks(:update_password) do
        update(password: self.new_password)
      end
    end
  end

  concerning :UpdateOneTimePassword do
    included do
      define_model_callbacks :update_one_time_password

      attribute :update_one_time_password_step, :string
      attribute :one_time_password_attempt, :string

      aasm(:update_one_time_password_step, enum: false) do
        state :intro, initial: true
        state :backup_codes
        state :verify
        state :completed

        event :next do
          transitions from: :intro, to: :backup_codes do
            after do
              self.backup_codes = self.class.generate_backup_codes
            end
          end
          transitions from: :backup_codes, to: :verify do
            guard do
              valid?(:update_one_time_password)
            end
            after do
              self.one_time_password_secret = self.class.generate_one_time_password_secret
            end
          end
          transitions from: :verify, to: :completed do
            guard do
              valid?(:update_one_time_password)
            end
            after do
              run_callbacks(:update_one_time_password) { save }
            end
          end
        end
      end

      with_options on: :update_one_time_password do
        validates :backup_codes_digest, presence: true, if: -> { self.update_one_time_password_step != "intro" }
        validates :one_time_password_secret, presence: true, if: -> { self.update_one_time_password_step == "verify" }
        validates :one_time_password_attempt, authenticate: :one_time_password, if: -> { self.update_one_time_password_step == "verify" }
      end
    end

    def update_one_time_password(attributes)
      self.attributes = attributes
      self.next && self.completed?
    end

    def disable_one_time_password!
      update!(one_time_password_secret: nil, one_time_password_last_used_at: nil, backup_codes_digest: nil)
    end
  end
end
