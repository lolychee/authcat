require 'spec_helper'

describe Authcat::Credentials::GlobalID do

  let(:user) { User.create(email: 'test@example.com', password: 'password') }

  let(:global_id) { ::GlobalID.create(user) }

  describe '#initialize' do
    context 'when gevin a valid value' do
      it 'return described_class instance' do
        credential = described_class.new(global_id.to_s)
        expect(credential).to be_is_a(described_class)
      end

      it '#global_id eq global_id' do
        credential = described_class.new(global_id.to_s)
        expect(credential.global_id).to eq global_id
      end

      it '#user eq user' do
        credential = described_class.new(global_id.to_s)
        expect(credential.user).to eq user
      end
    end

    context 'when gevin a invalid value' do
      it do
        expect {
          described_class.new('invalid value')
        }.to raise_error(Authcat::Credentials::InvalidCredential)
      end
    end
  end

  describe '#user=' do
    context 'when gevin a user' do
      it 'change #global_id to global_id' do
        expect {
          subject.user = user
        }.to change(subject, :global_id).to(global_id)
      end
    end

    context 'when gevin a nil' do
      it 'not to change #global_id' do
        expect {
          subject.user = nil
        }.not_to change(subject, :global_id)
      end
    end
  end

  describe '#to_s' do
    it 'eq #global_id.to_s' do
      expect(subject.to_s).to eq subject.global_id.to_s
    end
  end

end
