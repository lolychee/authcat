class User < ApplicationRecord
  include Authcat::Identifier
  include Authcat::MultiFactor

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

  concerning :ChangePassword do
    included do
      define_model_callbacks :change_password

      attr_accessor :old_password, :new_password

      with_options on: :change_password do
        validates :old_password, verify: :password, if: :password?
        validates :new_password, presence: true, confirmation: true
      end
    end

    def change_password(attributes = {})
      self.attributes = attributes
      valid?(:change_password) && run_callbacks(:change_password) do
        update(password: self.new_password)
      end
    end
  end

  concerning :UpdateOneTimePassword do
    included do
      define_model_callbacks :update_one_time_password

      attribute :update_one_time_password_step, :string, default: "intro"
      attribute :one_time_password_attempt, :string

      state_machine :update_one_time_password_step, initial: :intro, action: nil do
        after_transition from: :intro, to: :backup_codes do |record, transition|
          record.backup_codes = record.class.generate_backup_codes
        end
        after_transition from: :backup_codes, to: :verify do |record, transition|
          record.one_time_password_secret = record.class.generate_one_time_password_secret
        end

        event :next do
          transition intro: :backup_codes
          transition backup_codes: :verify, if: ->(record) { record.valid?(:update_one_time_password) }
          transition verify: :completed, if: -> (record) { record.valid?(:update_one_time_password) }
          transition any => same
        end
      end

      with_options on: :update_one_time_password do
        validates :backup_codes_digest, presence: true, if: -> { self.update_one_time_password_step != "intro" }
        validates :one_time_password_secret, presence: true, if: -> { self.update_one_time_password_step == "verify" }
        validates :one_time_password_attempt, verify: :one_time_password, if: -> { self.update_one_time_password_step == "verify" }
      end
    end

    def update_one_time_password(attributes)
      self.attributes = attributes
      self.next
      self.completed? && run_callbacks(:update_one_time_password) { save }
    end

    def disable_one_time_password!
      update!(one_time_password_secret: nil, one_time_password_last_used_at: nil, backup_codes_digest: nil)
    end
  end
end
