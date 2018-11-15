# frozen_string_literal: true

module Authcat
  module Model
    def self.included(base)
      base.include Token::Tokenable,
                   Password::SecurePassword,
                   Password::Validators,
                   TwoFactor::OneTimePassword,
                   TwoFactor::BackupCodes
    end
  end
end
