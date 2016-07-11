require 'spec_helper'

describe Authcat::Strategies::Session do

  let(:identity) { User.create(email: 'test@example.com', password: '123456') }

  let(:auth) { Authcat::Authenticator.new(mock_request) }

  let(:request) { auth.request }

  let(:key) { :remember_token }

  subject { described_class.new(auth, key: key) }

  describe '#authenticate' do
    context 'when session[key] is nil' do
      it 'should be nil' do
        request.session[key] = nil
        expect {
          subject.authenticate
        }.to raise_error(Authcat::Credentials::InvalidCredential)
      end
    end

    context 'when session[key] is valid' do
      it 'should be a identity' do
        request.session[key] = subject.create_credential(identity).to_s
        expect(subject.authenticate).to eq identity
      end
    end

    context 'when session[key] is invalid' do
      it 'should raise Authcat::Credentials::InvalidCredential' do
        request.session[key] = 'invalid value'
        expect {
          subject.authenticate
        }.to raise_error(Authcat::Credentials::InvalidCredential)
      end
    end
  end

  describe '#sign_in' do
    context 'when gevin a user' do
      it 'session[key] equal credential' do
        expect {
          subject.sign_in(identity)
        }.to change { request.session[key] }
      end
    end
  end

  describe '#sign_out' do
    context 'when gevin a nil' do
      it 'delete session[key]' do
        request.session[key] = 'token'
        expect{
          subject.sign_out
        }.to change { request.session.key?(key) }.to(false)
      end
    end
  end

  describe '#exists?' do
    context 'when session[key] is blank' do
      it 'should be false' do
        expect(subject).not_to be_exists
      end
    end

    context 'when session[key] is not blank' do
      it 'should be true' do
        request.session[key] = 'token'
        expect(subject).to be_exists
      end
    end
  end

  describe '#readonly?' do
    it 'should be false' do
      expect(subject).not_to be_readonly
    end
  end

end
