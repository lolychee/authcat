require 'spec_helper'

describe Authcat::Credentials::GlobalID do

  let(:user) { User.new(id: 1) }

  let(:global_id) { ::GlobalID.create(user).to_s }

  subject { described_class.new(global_id) }

  describe '.valid?' do
    context 'when gevin a valid credential' do
      it 'return true' do
        expect(described_class.valid?(global_id)).to eq true
      end
    end

    context 'when gevin an invalid credential' do
      it 'return false' do
        expect(described_class.valid?('invalid credential')).to eq false
      end
    end
  end

  describe '.generate_credential' do
    context 'when gevin a user' do
      it 'return a credential' do
        expect(described_class.generate_credential(user)).to eq global_id
      end
    end

    context 'when gevin a nil' do
      it 'return a credential' do
        expect{
          described_class.generate_credential(nil)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#find_user' do
    context 'when user exists' do
      let(:user) { User.create(email:'test@example.com', password: '123456') }

      it 'return a user' do
        expect(subject.find_user).to eq user
      end
    end

    context 'when user not exists' do
      it 'return a nil' do
        subject.update(User.new(id: 2))
        expect(subject.find_user).to eq nil
      end
    end
  end

end
