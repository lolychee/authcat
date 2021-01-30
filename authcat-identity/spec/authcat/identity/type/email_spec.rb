# frozen_string_literal: true

RSpec.describe Authcat::Identity::Type::Email do
  let(:email) { 'somebody@example.com' }

  it 'does something useful' do
    user = User.new(email: email)
    user.save

    expect(User.where(email: email)).to be_exists
  end
end
