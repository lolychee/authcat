# frozen_string_literal: true

RSpec.describe Authcat::Password::Algorithm::BCrypt do
  it_behaves_like "an algorithm" do
    let(:validator) { BCrypt::Password.method(:valid_hash?) }
  end
end
