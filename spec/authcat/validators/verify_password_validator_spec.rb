require "spec_helper"

describe Authcat::Validators::VerifyPasswordValidator do

  let!(:user_class) do
    Class.new(ActiveRecord::Base) do
      self.table_name = User.table_name

      include Authcat::Model::SecurePassword
      include Authcat::Validators

      password_attribute :password_digest
      attr_accessor :password

      validates :password, verify_password: true, on: :sign_in
    end
  end

  let(:password) { "password" }
  let(:user) { user_class.new.tap { |u| u.write_password(:password_digest, password) } }

  context "right password" do
    it "should be valid" do
      user.password = password

      expect(user).to be_valid(:sign_in)
    end
  end

  context "wrong password" do
    it "add a password error" do
      user.password = "wrong_password"

      expect(user).to be_invalid(:sign_in)
      expect(user.errors).to include(:password)
      expect(user.errors[:password]).to include("not match")
    end
  end

end
