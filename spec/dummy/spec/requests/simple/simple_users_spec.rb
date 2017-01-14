require 'rails_helper'

RSpec.describe "Simple::Users", type: :request do
  describe "GET /simple_users" do
    it "works! (now write some real specs)" do
      get simple_users_path
      expect(response).to have_http_status(200)
    end
  end
end
