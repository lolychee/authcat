require 'spec_helper'

describe Authcat::Providers do

  class TestProvidersAuthenticator
    include Authcat::Core
    include Authcat::Providers

    use :session, session_name: :auth_token
  end

  subject { TestProvidersAuthenticator.new(request) }
  let(:request) { mock_request }
  let(:user) { User.create(email: 'someone@example.com', password: 'password') }

  describe '#authenticate' do
    it '' do
      request.session[:auth_token] = user.to_global_id.to_s
      expect {
        subject.authenticate
      }.to change(subject, :user).to(user)
    end
  end

  describe '#sign_in' do
    it '' do
      expect {
        subject.sign_in(user)
      }.to change(request, :session).to({auth_token: user.to_global_id.to_s})
    end
  end

  describe '#sign_out' do
    it '' do
      request.session[:auth_token] = 'token'
      expect {
        subject.sign_out
      }.to change(request, :session).to({})
    end
  end

end
