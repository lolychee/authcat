# frozen_string_literal: true

RSpec.describe Authcat::Account::EnableOneTimePassword do
  class CustomUser < User
    include Authcat::Account::EnableOneTimePassword[:one_time_password]
  end

  it "enable one_time_password successfully" do
    user = CustomUser.create

    expect do
      expect(user.enable_one_time_password_step).to eq "intro"
      expect(user.enable_one_time_password).to eq false

      expect(user.enable_one_time_password_step).to eq "recovery_codes"
      expect(user.enable_one_time_password).to eq false

      expect(user.enable_one_time_password_step).to eq "verify"
      expect(user.enable_one_time_password(one_time_password_challenge: user.one_time_password.now)).to eq true
    end.to change(CustomUser.where.not(one_time_password: nil, recovery_codes: nil), :count).by(1)
                                                                                            .and change(user,
                                                                                                        :one_time_password)
      .and change(user, :updated_at)
  end
end
