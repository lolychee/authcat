require 'spec_helper'

describe Authcat::Strategies::Base do

  let!(:strategy_class) do
    Class.new(described_class) do
      def authenticate
        request.session[:auth_token]
      end
    end
  end

  let(:user) { User.new(id: 1) }

  let(:global_id) { ::GlobalID.create(user).to_s }
  let(:request) { mock_request }

  subject { strategy_class.new(request) }

  describe '#initialize'

  describe '#authenticate' do
    it 'should raise NotImplementedError' do
      expect {
        described_class.new(request).authenticate
      }.to raise_error(NotImplementedError)
    end
  end

  describe '#sign_in' do
    it 'should raise NotImplementedError' do
      expect {
        described_class.new(request).sign_in
      }.to raise_error(NotImplementedError)
    end
  end

  describe '#sign_out' do
    it 'should raise NotImplementedError' do
      expect {
        described_class.new(request).sign_out
      }.to raise_error(NotImplementedError)
    end
  end

  describe '#find_user'

  describe '#save_user'

  # describe '#parse_credential' do
  #   context 'when gevin a valid credential' do
  #     it 'return Authcat::Credentials::GlobalID instance' do
  #       expect(subject.parse_credential(global_id)).to be_is_a(Authcat::Credentials::GlobalID)
  #     end
  #   end
  #
  #   context 'when gevin a invalid credential' do
  #     it 'return nil' do
  #       expect(subject.parse_credential('invalid credential')).to be nil
  #     end
  #   end
  # end
  #
  # describe '#generate_credential' do
  #   context 'when gevin a user' do
  #     it 'return Authcat::Credentials::GlobalID instance' do
  #       expect(subject.generate_credential(user)).to be_is_a(Authcat::Credentials::GlobalID)
  #     end
  #   end
  #
  #   context 'when gevin a nil' do
  #     it 'raise ArgumentError' do
  #       expect{
  #         subject.generate_credential(nil)
  #       }.to raise_error(ArgumentError)
  #     end
  #   end
  # end

  describe '#credential_class' do
    it 'should be Credentials::GlobalID' do
      expect(subject.credential_class).to be Authcat::Credentials::GlobalID
    end

    it 'should be Credentials::GlobalID subclass' do
      subject.credential_class = :globalid
      expect(subject.credential_class.ancestors).to include Authcat::Credentials::GlobalID
    end

    it 'should be Credentials::GlobalID subclass' do
      subject.credential_class = [:globalid, signed: true]
      expect(subject.credential_class.ancestors).to include Authcat::Credentials::GlobalID
    end

  end

  describe '#readonly?' do
    it 'should be true' do
      expect(described_class.new(request)).to be_readonly
    end
  end

  describe '#present?' do
    it 'should be false' do
      expect(described_class.new(request)).not_to be_present
    end
  end
end
