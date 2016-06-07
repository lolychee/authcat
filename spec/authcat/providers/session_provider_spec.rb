require 'spec_helper'

describe Authcat::Providers::SessionProvider do

  class TestSessionAuthenticator < Authcat::Authenticator

  end

  let(:request) { mock_request }
  let(:authenticator) { TestSessionAuthenticator.new(request) }
  let(:user) { User.create(email: 'someone@example.com', password: 'password') }

  describe '#sign_in' do

    it 'write global_id to request' do
      provider = described_class.new(session_name: :auth_token)
      authenticator.sign_in(user)

      provider.sign_in(authenticator)

      expect(request.session).to include(provider.session_name)
      expect(request.session[provider.session_name]).to eq user.to_global_id.to_s
    end

  end

  describe '#authenticate' do
    it 'restore global_id from request' do
      provider = described_class.new(session_name: :auth_token)

      request.session[:auth_token] = user.to_global_id

      expect(provider.authenticate(authenticator)).to eq user
    end
  end

  describe '#sign_out' do

    it 'clear global_id on request' do
      provider = described_class.new(session_name: :auth_token)

      request.session[:auth_token] = user.to_global_id

      provider.sign_out(authenticator)

      expect(request.session).not_to include(:auth_token)
    end
  end

end
