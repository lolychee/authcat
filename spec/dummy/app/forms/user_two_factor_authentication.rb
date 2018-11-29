# frozen_string_literal: true

class UserTwoFactorAuthentication
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :enable_otp, :boolean
  attribute :otp_code

  attr_accessor :user
  delegate :otp_required, :otp, to: :user, allow_nil: true

  validate :otp_code_should_match, on: :register_otp

  def otp_provisioning_uri
    otp.provisioning_uri(user.email)
  end

  def save
    if otp
      if otp_required
        user.generate_otp_backup_codes if regenerate_otp_backup_codes
      else
        valid?(:register_otp) && user.generate_otp_backup_codes && user.update(otp_required: true)
      end
    else
      user.generate_otp if enable_otp
    end
  end

  private

    def otp_code_should_match
      errors.add(:otp_code, "not match") unless user.otp_verify(otp_code)
    end
end
