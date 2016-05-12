require 'spec_helper'

describe Authcat::Authenticator do

  class TestEmptyAuthenticator < Authcat::Authenticator
  end

  class TestAuthenticator < Authcat::Authenticator
    use :session, session_name: :auth_token
  end


  describe '#authenticate' do
    it '' do
      auth = TestAuthenticator.new(mock_request)
      expect(auth.authenticate).to be nil
    end
  end
end
