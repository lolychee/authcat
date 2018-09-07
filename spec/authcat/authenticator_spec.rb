# frozen_string_literal: true

require "spec_helper"

describe Authcat::Authenticator do
  let!(:app) { Rails.application }

  let(:user) { User.create!(email: "someone@example.com", password: "password") }

  describe "#authenticate" do
    it "" do
      # middleware = Authcat::Authenticator.new(app) do
      #   from :session, User
      # end

      req = Rack::MockRequest.new(app)

      resp = req.get("/", "HTTP_COOKIE" => "access_token=#{User.tokenize(user)}")

      # binding.pry
    end
  end
end
