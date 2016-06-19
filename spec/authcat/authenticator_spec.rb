require 'spec_helper'

describe Authcat::Authenticator do

  let!(:authenticator_class) do
    Class.new(Authcat::Authenticator) do
      use :session, key: :auth_token
    end
  end

  describe '#authenticate' do
    it '' do
      auth = authenticator_class.new(mock_request)
      expect(auth.authenticate).to be nil
    end
  end
end
