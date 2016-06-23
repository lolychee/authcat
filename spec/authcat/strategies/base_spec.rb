require 'spec_helper'

describe Authcat::Strategies::Base do

  let!(:strategy_class) do
    Class.new(described_class) do
      def find_credential(request)
        request.session[:auth_token]
      end
    end
  end

  let(:user) { User.new(id: 1) }

  let(:global_id) { ::GlobalID.create(user).to_s }

  subject { strategy_class.new }

  describe '#initialize'

  describe '#find_credential' do
    it 'raise NotImplementedError' do
      expect {
        described_class.new.find_credential(nil)
      }.to raise_error(NotImplementedError)
    end
  end

  describe '#save_credential' do
    it 'raise NotImplementedError' do
      expect {
        described_class.new.save_credential(nil, nil)
      }.to raise_error(NotImplementedError)
    end
  end

  describe '#has_credential?' do
    it 'raise NotImplementedError' do
      expect {
        described_class.new.has_credential?(nil)
      }.to raise_error(NotImplementedError)
    end
  end

  describe '#find_user'

  describe '#save_user'

  describe '#parse_credential' do
    context 'when gevin a valid credential' do
      it 'return Authcat::Credentials::GlobalID instance' do
        expect(subject.parse_credential(global_id)).to be_is_a(Authcat::Credentials::GlobalID)
      end
    end

    context 'when gevin a invalid credential' do
      it 'return nil' do
        expect(subject.parse_credential('invalid credential')).to be nil
      end
    end
  end

  describe '#generate_credential' do
    context 'when gevin a user' do
      it 'return Authcat::Credentials::GlobalID instance' do
        expect(subject.generate_credential(user)).to be_is_a(Authcat::Credentials::GlobalID)
      end
    end

    context 'when gevin a nil' do
      it 'raise ArgumentError' do
        expect{
          subject.generate_credential(nil)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#readonly?' do
    it 'return true' do
      expect(described_class.new).to be_readonly
    end
  end
end
