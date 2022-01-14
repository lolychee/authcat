# frozen_string_literal: true

RSpec.describe Authcat::Account::ChangePassword do
  class CustomUser < User
    include Authcat::Account::ChangePassword[:password]
  end

  let(:old_password) { "123456" }
  let(:new_password) { "qwerty" }

  it "update password successfully" do
    user = CustomUser.create(password: old_password)

    expect(user.password).to eq old_password
    expect do
      user.change_password(
        old_password: old_password,
        new_password: new_password,
        new_password_confirmation: new_password
      )
    end.to change(user, :password)
    expect(user.password).to eq new_password
  end
end
