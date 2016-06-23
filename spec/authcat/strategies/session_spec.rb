require 'spec_helper'

describe Authcat::Strategies::Session do

  let(:user) { User.create(email: 'test@example.com', password: '123456') }

  let(:request) { mock_request }

  let(:key) { :remember_token }

  subject { described_class.new(key: key) }

  describe '#find_credential' do

    context 'when session[key] is nil' do
      it 'return nil' do
        request.session[key] = nil
        expect(subject.find_credential(request)).to be_nil
      end
    end

    context 'when session[key] is valid' do
      it 'return Credentials::Base instance' do
        request.session[key] = subject.generate_credential(user).to_s
        expect(subject.find_credential(request)).to be_is_a(Authcat::Credentials::Base)
      end
    end

    context 'when session[key] is invalid' do
      it do
        request.session[key] = 'invalid value'
        expect(subject.find_credential(request)).to be nil
      end
    end

  end

  describe '#save_credential' do
    context 'when gevin a nil' do
      it 'delete session[key]' do
        request.session[key] = 'token'
        expect{
          subject.save_credential(request, nil)
        }.to change { request.session[key] }.to(nil)
      end
    end

    context 'when gevin a credential' do
      it 'session[key] equal credential' do
        credential = subject.generate_credential(user)
        expect {
          subject.save_credential(request, credential)
        }.to change { request.session[key] }.to(credential.to_s)
      end
    end

  end

  describe '#has_credential?' do

    context 'when session[key] is blank' do
      it 'return false' do
        expect(subject).not_to be_has_credential(request)
      end
    end

    context 'when session[key] is not blank' do
      it 'return true' do
        request.session[key] = 'token'
        expect(subject).to be_has_credential(request)
      end
    end

  end

  describe '#readonly?' do
    it 'return false' do
      expect(subject).not_to be_readonly
    end
  end

end
