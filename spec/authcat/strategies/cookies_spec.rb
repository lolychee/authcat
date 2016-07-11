require 'spec_helper'

describe Authcat::Strategies::Cookies do
  let(:identity) { User.create(email: 'test@example.com', password: '123456') }

  let(:auth) { Authcat::Authenticator.new(mock_request) }

  let(:request) { auth.request }

  let(:key) { :remember_token }

  subject { described_class.new(auth, key: key) }

  describe '#authenticate' do
    context 'when cookies[key] is nil' do
      it 'should be nil' do
        request.cookie_jar[key] = nil
        expect {
          subject.authenticate
        }.to raise_error(Authcat::Credentials::InvalidCredential)
      end
    end

    context 'when cookies[key] is valid' do
      it 'should be a identity' do
        request.cookie_jar[key] = subject.create_credential(identity).to_s
        subject.encrypted = false
        expect(subject.authenticate).to eq identity
      end
    end

    context 'when cookies[key] is invalid' do
      it 'should raise Authcat::Credentials::InvalidCredential' do
        request.cookie_jar[key] = 'invalid value'
        expect {
          subject.authenticate
        }.to raise_error(Authcat::Credentials::InvalidCredential)
      end
    end
  end

  describe '#sign_in' do
    context 'when gevin a identity' do
      it 'cookies[key] equal credential' do
        expect {
          subject.sign_in(identity)
        }.to change { request.cookie_jar[key] }
      end
    end
  end

  describe '#sign_out' do
    context 'when gevin a nil' do
      it 'delete cookies[key]' do
        request.cookie_jar[key] = 'token'
        expect{
          subject.sign_out
        }.to change { request.cookie_jar.key?(key) }.to(false)
      end
    end
  end

  describe '#cookies' do
    context 'when encrypted: true' do
      it 'should be ActionDispatch::Cookies::EncryptedCookieJar instance' do
        subject.encrypted = true
        expect(subject.cookies).to be_is_a(ActionDispatch::Cookies::EncryptedCookieJar)
      end
    end

    context 'when signed: true' do
      it 'should be ActionDispatch::Cookies::PermanentCookieJar instance' do
        subject.encrypted = false
        subject.signed = true
        expect(subject.cookies).to be_is_a(ActionDispatch::Cookies::SignedCookieJar)
      end
    end

    context 'when permanent: true' do
      it 'should be ActionDispatch::Cookies::PermanentCookieJar instance' do
        subject.encrypted = false
        subject.permanent = true
        expect(subject.cookies).to be_is_a(ActionDispatch::Cookies::PermanentCookieJar)
      end
    end
  end

  describe '#exists?' do
    context 'when cookies[key] is blank' do
      it 'should be false' do
        expect(subject).not_to be_exists
      end
    end

    context 'when cookies[key] is not blank' do
      it 'should be true' do
        request.cookie_jar[key] = 'token'
        expect(subject).to be_present
      end
    end
  end

  describe '#readonly?' do
    it 'should be false' do
      expect(subject).not_to be_readonly
    end
  end


end
