require 'spec_helper'

describe Authcat::Credentials::Base do

  let!(:credential_class) do
    Class.new(described_class) do |klass|
      def klass.valid?(credential)
        credential =~ /^\w+:[0-9]+$/
      end

      def klass.create(user, **options)
        new([user.class.name, user.id].join(':'), **options)
      end

      def find_user
        klass, id = self.split(':')
        klass.constantize.find(id)
      end
    end
  end

  let(:credential) { credential_class.create(user) }

  let(:user) { User.new(id: 1) }

  describe '.create' do
    context 'when given a user' do
      it 'should be a credential' do
        expect(credential_class.create(user)).to be_is_a(credential_class)
      end
    end
  end

  describe '.valid?' do
    it 'should raise NotImplementedError' do
      expect {
        described_class.valid?('')
      }.to raise_error(NotImplementedError)
    end
  end

  describe '#replace' do
    context 'when given an invalid credential' do
      it 'should raise InvalidCredential' do
        expect {
          credential.replace('invalid credential')
        }.to raise_error(Authcat::Credentials::InvalidCredential)
      end
    end

    context 'when given a valid credential' do
      it 'should replace with valid credential' do
        expect(credential.replace('User:1')).to eq 'User:1'
      end
    end
  end

  describe '#update' do
    context 'when given a user' do
      it 'should update to new credential' do
        new_user = User.new(id: 2)
        expect(credential.update(new_user)).to eq 'User:2'
      end
    end
  end

  describe '#find_user' do
    it 'should raise NotImplementedError' do
      expect {
        described_class.new('').find_user
      }.to raise_error(NotImplementedError)
    end
  end

end
