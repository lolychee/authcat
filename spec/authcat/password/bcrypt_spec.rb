require 'spec_helper'

describe Authcat::Password::BCrypt do

  let(:password) { 'password' }

  describe '.valid?' do
    it do
      expect(described_class.valid?(::BCrypt::Password.create(password).to_s)).to eq true
    end
  end

  describe '.valid_salt?' do
    it 'should be true' do
      salt = ::BCrypt::Engine.generate_salt
      expect(described_class.valid_salt?(salt)).to eq true
    end
  end

  describe '#replace'

  describe '#generate_salt'

  describe '#hash' do
    it 'should be true' do
      expect(described_class.valid?(subject.send(:hash, password))).to eq true
    end
  end

  describe '#extract_hash' do
    let(:hashed_password) { '$2b$05$9eqmbgDaM9M9O54VG4gW8.BBzUMU6GapCD2g107F/gsiDUA5OWO9O' }

    it 'should change #version' do
      expect{
        subject.send(:extract_hash, hashed_password)
      }.to change(subject, :version).to('2b')
    end

    it 'should change #cost' do
      expect{
        subject.send(:extract_hash, hashed_password)
      }.to change(subject, :cost).to(5)
    end

    it 'should change #salt' do
      expect{
        subject.send(:extract_hash, hashed_password)
      }.to change(subject, :salt).to('$2b$05$9eqmbgDaM9M9O54VG4gW8.')
    end
  end
end
