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

      req.get("/", {"HTTP_COOKIE" => "access_token=#{user.to_token}"})
      # binding.pry
      expect(auth.authenticate).to be nil
    end
  end
end
