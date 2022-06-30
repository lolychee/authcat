# frozen_string_literal: true

RSpec.describe Authcat::Password::Engines::BCrypt do
  it_behaves_like "a engine" do
    let(:validator) { ::BCrypt::Password.method(:valid_hash?) }
  end
end
