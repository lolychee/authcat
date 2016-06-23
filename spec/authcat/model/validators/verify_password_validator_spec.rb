require 'spec_helper'

describe Authcat::Model::Validators::VerifyPasswordValidator do

  let!(:user_class) do
    Class.new(ActiveRecord::Base) do
      self.table_name = User.table_name

      include Authcat::Model::Password
      include Authcat::Model::Validators

      password_attribute :password_digest
      attr_accessor :password

      validates :password, verify_password: true, on: :sign_in
    end
  end

  let(:password) { 'password' }
  let(:user) { user_class.new.tap {|u| u.write_password(:password_digest, password) } }

  describe '正确的密码' do
    it '通过校验' do
      user.password = password

      expect(user).to be_valid(:sign_in)
    end
  end

  describe '错误的密码' do
    it 'errors 添加一个 password 项' do
      user.password = 'wrong_password'

      expect(user).to be_invalid(:sign_in)
      expect(user.errors).to include(:password)
      expect(user.errors[:password]).to include('not match')
    end
  end

end
