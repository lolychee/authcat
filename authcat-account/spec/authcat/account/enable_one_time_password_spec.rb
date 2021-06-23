# frozen_string_literal: true

RSpec.describe Authcat::Account::EnableOneTimePassword do
  before(:context) { User.include described_class[:one_time_password] }

  after(:context) { Object.send(:remove_const, :User) }

  let(:old_password) { "123456" }
  let(:new_password) { "qwerty" }

  it "enable one_time_password successfully" do
    user = User.create

    expect(user.password).to eq old_password
    expect {
      user.update_password(
        old_password: old_password,
        new_password: new_password,
        new_password_confirmation: new_password
      )
    }.to change(user, :password)
    expect(user.password).to eq new_password
  end
end
