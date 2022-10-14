# frozen_string_literal: true

RSpec.describe Authcat::Identity::Formatters::Email do
  let(:email) { "somebody@example.com" }
  let(:email_masked) { "s*****dy@e******.com" }

  it "does something useful" do
    user = User.new(email: email)
    user.save

    expect(User.email.identify(email)).to be_persisted
    # expect(user.email_masked).to eq email_masked
  end
end
