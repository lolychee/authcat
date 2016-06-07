require 'spec_helper'

describe Authcat::Password::BCrypt do

  let(:password) { 'password' }

  describe '.digest' do
    it '返回正确的密码摘要' do
      hashed_password = described_class.create(password)
      expect(::BCrypt::Password.new(hashed_password.to_s) == password)
    end
  end

  describe '.verify' do
    it '' do
      hashed_password = ::BCrypt::Password.create(password)
      expect(described_class.verify(hashed_password, password))
    end
  end
end
