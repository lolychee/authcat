require 'spec_helper'

describe Authcat::Strategies::Base do

  let!(:strategy_class) do
    Class.new(described_class) do
      def authenticate
        request.session[:auth_token]
      end
    end
  end

  let(:identity) { User.create(email: 'test@example.com', password: '123456') }

  let(:global_id) { ::GlobalID.create(identity).to_s }

  let(:auth) { Authcat::Authenticator.new(mock_request) }

  let(:request) { auth.request }

  subject { strategy_class.new(auth) }

  describe '#initialize'

  describe '#authenticate' do
    it 'should be nil' do
      expect(subject.authenticate).to be nil
    end
  end

  describe '#sign_in' do
    it 'should be identity' do
      auth.identity = identity
      expect(subject.sign_in).to be identity
    end
  end

  describe '#sign_out' do
    it 'should be nil' do
      expect(subject.sign_out).to be nil
    end
  end

  describe '#find_user'

  describe '#save_user'

  describe '#parse_credential' do
    context 'when given a valid credential' do
      it 'return Authcat::Credentials::GlobalID instance' do
        expect(subject.parse_credential(global_id)).to be_is_a(Authcat::Credentials::GlobalID)
      end
    end

    context 'when given a invalid credential' do
      it 'raise Authcat::Errors::InvalidCredential' do
        expect{
          subject.parse_credential('invalid credential')
        }.to raise_error(Authcat::Errors::InvalidCredential)
      end
    end
  end

  describe '#create_credential' do
    context 'when given a identity' do
      it 'return Authcat::Credentials::GlobalID instance' do
        expect(subject.create_credential(identity)).to be_is_a(Authcat::Credentials::GlobalID)
      end
    end

    context 'when given a nil' do
      it 'raise ArgumentError' do
        expect{
          subject.create_credential(nil)
        }.to raise_error(ArgumentError)
      end
    end
  end

  # describe '#credential_class' do
  #   it 'should be Credentials::GlobalID' do
  #     expect(subject.credential_class).to be Authcat::Credentials::GlobalID
  #   end
  #
  #   it 'should be Credentials::GlobalID subclass' do
  #     subject.credential_class = :globalid
  #     expect(subject.credential_class.ancestors).to include Authcat::Credentials::GlobalID
  #   end
  #
  #   it 'should be Credentials::GlobalID subclass' do
  #     subject.credential_class = [:globalid, signed: true]
  #     expect(subject.credential_class.ancestors).to include Authcat::Credentials::GlobalID
  #   end
  #
  # end

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
