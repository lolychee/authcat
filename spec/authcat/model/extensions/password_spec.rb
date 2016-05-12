require 'spec_helper'

describe Authcat::Model::Extensions::Password do

  class TestModel
    include Authcat::Model::Extensions::Password

    attr_accessor :password_digest
    attr_accessor :password_second_hashed

    define_password_attribute :password
    define_password_attribute :password_second, suffix: :hashed
  end

  let(:model) { TestModel.new }
  let(:password) { '123456' }

  describe '.define_password_attribute' do
    it '生成 password writer' do
      expect(model).to respond_to(:password=)
    end

    it '生成密码摘要' do
      model.password = password
      hashed_password = Authcat::Digest::BCrypt.new(model.password_digest).digest(password)

      expect(model.password_digest).to eq hashed_password
    end

    it '可以自定义后缀' do
      model.password_second = password
      expect(model.password_second_hashed).to be_present
    end
  end

  describe '#authenticate' do
    it '' do
      model.password = password
      expect(model.authenticate(password: password))
    end
  end

end
