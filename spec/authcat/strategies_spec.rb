require 'spec_helper'

describe Authcat::Strategies do

  let(:authenticator_class) do
    Class.new do
      include Authcat::Core
      include Authcat::Strategies

      use :session, key: :auth_token
    end
  end

  subject { authenticator_class.new(request) }
  let(:request) { mock_request }
  let(:identity) { User.create(email: 'someone@example.com', password: 'password') }

  describe '#authenticate' do
    it '' do
      request.session[:auth_token] = identity.to_global_id.to_s
      expect {
        subject.authenticate
      }.to change(subject, :identity).to(identity)
    end
  end

  describe '#sign_in' do
    it '' do
      expect {
        subject.sign_in(identity)
      }.to change(request, :session).to({auth_token: identity.to_global_id.to_s})
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
