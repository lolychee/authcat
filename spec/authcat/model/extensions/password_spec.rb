require 'spec_helper'

describe Authcat::Model::Extensions::Password do

  class TestPasswordUser < ActiveRecord::Base
    self.table_name = User.table_name

    include Authcat::Model::Extensions::Password

    attr_accessor :password

    password_attribute :password_digest

    before_save {|record| record.create_password(:password_digest, record.password) }
  end

  let(:password) { 'password' }
  let(:user) { TestPasswordUser.create(email: 'someone@example.com', password: password) }

  describe '.password_attribute' do
    it '生成 #password_digest' do
      expect(user).to respond_to(:password_digest)
    end

    it '生成 #password_digest=' do
      expect(user).to respond_to(:password_digest=)
    end

    it '生成密码摘要' do
      expect(user.password_digest).to be_kind_of(Authcat::Password)
      expect(user.password_digest.verify(password))
    end
  end

  # describe '#authenticate' do
  #   it '' do
  #     model.password = password
  #     expect(model.password_verify(:password, password))
  #   end
  # end

end
