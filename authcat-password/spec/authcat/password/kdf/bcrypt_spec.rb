# frozen_string_literal: true

RSpec.describe Authcat::Password::KDF::BCrypt do
  it_behaves_like "a kdf" do
    let(:validator) { ::BCrypt::Password.method(:valid_hash?) }
  end
end
