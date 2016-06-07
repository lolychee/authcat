require 'spec_helper'

describe Authcat::Model::Validators::RecordFoundValidator do

  class TestRecordFoundValidatorUser < ActiveRecord::Base
    self.table_name = User.table_name

    include Authcat::Model

    password_attribute :password_digest
    attr_accessor :password

    validates :email, record_found: true, on: :sign_in

    before_save {|user| user.create_password(:password_digest, user.password) }
  end

  describe '存在的邮件地址' do
    # 时间存入SQLite数据库会丢失精度，reload来同步
    let(:someone) { TestRecordFoundValidatorUser.create(email: 'someone@example.com', password: 'password').reload }

    it '更新 user 属性' do
      user = TestRecordFoundValidatorUser.new(email: someone.email)
      expect(user.valid?(:sign_in))
      expect(user.instance_variable_get('@attributes')).to eq someone.instance_variable_get('@attributes')
    end
  end

  describe '不存在的邮件地址' do
    it 'errors 添加一个 email 项' do
      user = user = TestRecordFoundValidatorUser.new(email: 'someone@example.com')
      expect(user.invalid?(:sign_in))
      expect(user.errors).to include(:email)
      expect(user.errors[:email]).to include('not found')
    end
  end

end
