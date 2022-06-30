# frozen_string_literal: true

RSpec.describe Authcat::Account::SignIn do
  class CustomSession < ActiveRecord::Base
    self.table_name = Session.table_name

    include Authcat::Account

    attribute :email
    attribute :phone_number

    attribute :password
    attribute :one_time_password

    include Authcat::Account::SignIn.new
  end

  let(:email) { "u1@email.com" }
  let(:password) { "123456" }

  it "update password successfully" do
    User.create(email: email, password: password)

    session = CustomSession.new
    expect(
      session.sign_in(
        email: email,
        password: password
      )
    ).to eq true
  end
end
