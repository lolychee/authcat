# frozen_string_literal: true

RSpec.describe Authcat::Account::ChangePassword do
  before(:context) { User.include described_class[:password] }

  after(:context) { Object.send(:remove_const, :User) }

  let(:old_password) { "123456" }
  let(:new_password) { "qwerty" }

  it "update password successfully" do
    user = User.create(password: old_password)

    expect(user.password).to eq old_password
    expect {
      user.change_password(
        old_password: old_password,
        new_password: new_password,
        new_password_confirmation: new_password
      )
    }.to change(user, :password)
    expect(user.password).to eq new_password
  end
end
