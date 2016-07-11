require 'spec_helper'

describe Authcat::Credentials::GlobalID do

  let(:user) { User.new(id: 1) }

  let(:global_id) { ::GlobalID.create(user).to_s }

  subject { described_class.new(global_id) }

  describe '.create' do
    context 'when gevin a user' do
      it 'should be a credential' do
        expect(described_class.create(user)).to eq global_id
      end
    end

    context 'when gevin a nil' do
      it 'should be a credential' do
        expect{
          described_class.create(nil)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe '.valid?' do
    context 'when gevin a valid credential' do
      it 'should be true' do
        expect(described_class.valid?(global_id)).to eq true
      end
    end

    context 'when gevin an invalid credential' do
      it 'should be false' do
        expect(described_class.valid?('invalid credential')).to eq false
      end
    end
  end

  describe '#find' do
    context 'when user exists' do
      let(:user) { User.create(email:'test@example.com', password: '123456') }

      it 'should be a user' do
        expect(subject.find).to eq user
      end
    end

    context 'when user not exists' do
      it 'should be a nil' do
        subject.update(User.new(id: 2))
        expect(subject.find).to eq nil
      end
    end
  end

end