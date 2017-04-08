require 'spec_helper'

describe Authcat::Strategies::Abstract do
  let!(:strategy_class) do
    Class.new(described_class) do
      def self.key
        'token'
      end

      def _read
        credential_class.new(request.session[self.class.key])
      end

      def _write(credential)
        request.session[self.class.key] = credential.to_s
      end

      def _clear
        request.session.delete(self.class.key)
      end

      def exists?
        request.session.key?(self.class.key)
      end

      def readonly?
        false
      end

    end
  end

  let(:identity) { User.create(email: 'test@example.com', password: '123456') }

  let(:credential) { credential_class.create(identity) }

  let(:credential_class) { Authcat::Credentials::GlobalID }

  let(:auth) { Authcat::Authenticator.new(mock_request) }

  let(:request) { auth.request }

  subject { strategy_class.new(auth, credential: credential_class) }

  describe '#read' do

    context 'when credential data exists' do
      before(:example) { request.session[strategy_class.key] = credential.to_s }

      it 'should be credential' do
        expect(subject.read).to be_a(Authcat::Credentials::Abstract)
      end
    end

    context 'when credential data does not exists' do
      it 'should eq nil' do
        expect(subject.read).to eq nil
      end
    end

  end

  describe '#write' do
    it 'should write credential' do
      expect{
        subject.write(credential)
      }.to change { request.session.key?(strategy_class.key) }.from(false).to(true)
    end
  end

  describe '#clear' do
    before(:example) { request.session[strategy_class.key] = credential.to_s }

    it 'should clear credential' do
      expect{
        subject.clear
      }.to change { request.session.key?(strategy_class.key) }.from(true).to(false)
    end
  end

  describe '#readonly?' do
    it 'should be true' do
      expect(described_class.new(request)).to be_readonly
    end
  end

  describe '#exists?' do
    it 'should be false' do
      expect(described_class.new(request)).not_to be_exists
    end
  end

end
