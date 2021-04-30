# frozen_string_literal: true

RSpec.describe Authcat::Identifier::Types::Email do
  let(:email) { 'somebody@example.com' }
  let(:email_masked) { 's*****dy@e******.com' }

  it 'does something useful' do
    user = User.new(email: email)
    user.save

    expect(User.where(email: email)).to be_exists
    expect(user.email_masked).to eq email_masked
  end
end
