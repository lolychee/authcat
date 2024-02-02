# frozen_string_literal: true

require "rack/test"

RSpec.describe Authcat::Authenticator::Providers::Cookie do
  include Rack::Test::Methods

  let(:endpoint) { proc { [200, {}, ["Hello, world!"]] } }
  # let(:middleware) { Authcat::Authenticator::Middleware.new(endpoint) }
  let(:app) { endpoint }

  let(:user) { User.create(email: "someone@example.com") }

  context "with User" do
    # before do
    #   middleware.configure do
    #     provider :cookie, key: "token" do |pipeline|
    #       pipeline << :jwt
    #     end

    #     identity :user do
    #       serializer :json
    #     end
    #   end
    # end

    it "responds with success when called" do
      set_cookie("token=#{user.id}")
      get "/"

      expect(last_response).to be_ok
      expect(Current.user).to be_a(User)
    end
  end
end
