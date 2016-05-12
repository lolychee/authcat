require 'spec_helper'

describe Authcat::Providers::SessionProvider do

  # class TestSessionAuthenticator < Authcat::Authenticator
  #   include Authcat::Strategies::Session
  #
  #   session_name :auth_token
  #
  # end

  describe '#initialize' do
    it  do
      options = {
        session_name: :current_user
      }
      provider = Authcat::Providers::SessionProvider.new(**options)
      expect(provider.options).to eq options

      Authcat::Providers::AbstractProvider.configure(one: :one)
      Authcat::Providers::SessionProvider.configure(two: :two)

      expect(Authcat::Providers::AbstractProvider.default_options).to eq Authcat::Providers::SessionProvider.default_options
    end
  end

  describe '#read' do


    it do

    end

  end

  describe '#write' do

  end

end
