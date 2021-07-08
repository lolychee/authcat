# frozen_string_literal: true

RSpec.describe Authcat::Password::Crypto::BCrypt do
  it_behaves_like "a crypto" do
    let(:validator) { ::BCrypt::Password.method(:valid_hash?) }
  end
end
