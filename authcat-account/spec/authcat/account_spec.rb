# frozen_string_literal: true

RSpec.describe Authcat::Account do
  it "has a version number" do
    expect(Authcat::Account::VERSION).not_to be_nil
  end
end
