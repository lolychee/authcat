# frozen_string_literal: true

class UserSession < ApplicationRecord
  include Authcat::Session::SessionRecord

  belongs_to :user, optional: true, default: -> { User.new }

  # track :ip, :country, :region, :city, :location, :user_agent

  # extra_action :sign_in, do: lambda {
  #                              identify if !user.persisted? && may_identify?
  #                              authenticate
  #                            }, builder: SignIn do |_builder|
  #   auth_method :password, verifier: :password, identifier: :login
  # end

  # enum state: %w[identifying authenticating two_factor_authenticating authenticated revoked expired]
  attribute :identify_only, :boolean, default: false

  enum auth_method: %i[login password one_time_password recovery_codes], _prefix: true

  attr_accessor :login, :email, :phone_number, :password, :one_time_password, :recovery_code

  with_options on: :identify, unless: -> { user&.persisted? } do
    validates :login, :email, :phone_number, presence: true, identify: :user, allow_nil: true,
                                             if: -> { auth_method_password? || auth_method_login? }
  end

  with_options on: :authenticate do
    validates :password,          challenge: { delegate: :user }, if: :auth_method_password?
    validates :recovery_codes,    challenge: { delegate: :user }, if: :auth_method_recovery_codes?
  end

  with_options on: :two_factor_authenticate do
    validates :one_time_password, challenge: { delegate: :user }, if: :auth_method_one_time_password?
  end

  state_machine :state, initial: "identifying" do
    event :identify do
      transition from: "identifying", to: "authenticating", if: ->(r) { r.valid?(:identify) && r.user.persisted? }
    end

    event :authenticate do
      transition from: "authenticating", to: "two_factor_authenticating",
                 if: ->(r) { r.user.two_factor_authentication_required? && r.valid?(:authenticate) }
      transition from: "authenticating", to: "authenticated",
                 if: ->(r) { !r.user.two_factor_authentication_required? && r.valid?(:authenticate) }
      transition from: "two_factor_authenticating", to: "authenticated",
                 if: ->(r) { r.valid?(:two_factor_authenticate) }
    end
    after_transition to: %w[authenticating two_factor_authenticating], do: :set_auth_method

    event :revoke do
      transition from: all, to: "revoked", if: ->(r) { r.valid?(:revoke) }
    end

    event :expire do
      transition from: all - %w[revoked expired], to: "expired", if: ->(r) { r.valid?(:expire) }
    end
  end

  after_find :set_auth_method

  def sign_in(attributes = {})
    assign_attributes(attributes)

    if can_identify?
      return identify if identify_only?

      identify(false)
    end
    can_authenticate? && authenticate
  end

  def identify_only?
    user.avaliable_identify_auth_methods.include?(auth_method)
  end

  def set_auth_method
    if authenticating?
      self.auth_method = user.default_auth_method unless user.avaliable_auth_methods.include?(auth_method)
    elsif two_factor_authenticating?
      unless user.avaliable_two_factor_auth_methods.include?(auth_method)
        self.auth_method = user.default_two_factor_auth_method
      end
    end
  end

  extra_action :sign_out, do: :destroy

  extra_action :revoke, do: :destroy
end
