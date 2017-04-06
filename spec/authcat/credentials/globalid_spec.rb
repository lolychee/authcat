require 'spec_helper'

describe Authcat::Credentials::GlobalID do

  let(:user) { User.new(id: 1) }

  let(:global_id) { ::GlobalID.create(user).to_s }

  subject { described_class.new(global_id) }

  describe '#update' do
    context 'when given a user' do
      it 'should be a credential' do
        expect(subject.update(user).to_s).to eq global_id
      end
    end

    context 'when given a nil' do
      it 'should be a credential' do
        expect{
          subject.update(nil)
        }.to raise_error(Authcat::Credentials::InvalidIdentityError)
      end
    end
  end

  describe '.valid?' do
    context 'when given a valid credential' do
      it 'should be true' do
        expect(described_class.valid?(global_id)).to eq true
      end
    end

    context 'when given an invalid credential' do
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
