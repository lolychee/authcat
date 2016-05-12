require 'spec_helper'

describe Authcat::Digest::BCrypt do
  let(:password) { 'password' }

  describe '.digest' do
    it '返回正确的密码摘要' do
      hashed_password = Authcat::Digest::BCrypt.digest(password)
      expect(::BCrypt::Password.new(hashed_password.to_s) == password)
    end
  end

  describe '.compare' do
    it '' do
      hashed_password = ::BCrypt::Password.create(password)
      expect(Authcat::Digest::BCrypt.compare(hashed_password, password))
    end
  end
end
