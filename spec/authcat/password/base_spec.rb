require 'spec_helper'

describe Authcat::Password::Base do
  let!(:password_class) do
    Class.new(described_class) do |klass|

      def klass.valid?(hashed_password)
        hashed_password =~ /^=\w*$/
      end

      private

        def hash(password)
          "=#{password.reverse}"
        end
    end
  end

  let(:password) { password_class.new }
  let(:raw_password) { 'password' }
  let(:password_digest) { '=drowssap' }

  describe '.create' do
    it do
      expect(password_class.create(raw_password)).to eq password_digest
    end
  end

  describe '.verify'

  describe '.valid?' do
    it 'raise NotImplementedError' do
      expect {
        described_class.valid?(nil)
      }.to raise_error(NotImplementedError)
    end
  end

  describe '#initialize' do
    context 'when given a digest password' do
      it do
        expect(password_class.new(password_digest)).to be_a(password_class)
      end
    end
    context 'when given a nil' do
      it do
        expect(password_class.new(nil)).to be_a(password_class)
      end
    end
  end

  describe '#replace' do
    context 'when given a digest password' do
      it do
        expect{
          password.replace('=edcba')
        }.to change(password, :to_s).to('=edcba')
      end
    end
  end

  describe '#update'

  describe '#=='

  describe '#verify'

  describe '#digest' do
    it 'return new password' do
      expect(password.digest(raw_password)).not_to equal password
    end
  end

  describe '#hash' do
    it 'raise NotImplementedError' do
      expect {
        described_class.new.send(:hash, nil)
      }.to raise_error(NotImplementedError)
    end
  end

end
