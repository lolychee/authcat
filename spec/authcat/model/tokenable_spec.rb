require "spec_helper"

describe Authcat::Model::Tokenable do

  let(:user) { User.create(email: "someone@example.com", password: "password") }

  describe ".find_by_token" do
    it do
      token = user.to_token
      expect(User.find_by_token(token)).to eq user
    end
  end

  describe ".to_token" do
  end
end