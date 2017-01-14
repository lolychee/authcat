require 'rails_helper'

RSpec.describe "Simple::SessionsController", type: :request do
  describe "GET /simple/sign_in" do
    it "works! (now write some real specs)" do
      get simple_sign_in_path
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /simple/sign_in" do
    it do
      post simple_sign_in_path, params: {session: {email: 'someone@example.com', password: '123456'}}
      expect(response).to redirect_to(simple_root_path)
    end
  end
end
