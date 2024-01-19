# frozen_string_literal: true

RSpec.describe Authcat::Identifier::Reflections::HasMany do
  let(:public_email) { "public_email@example.com" }

  before do
    stub_const("User", Class.new(ActiveRecord::Base) do
      include Authcat::Identifier

      has_many_identifiers :emails, identify: { identifier: :identifier }
    end)
  end

  it "identify by emails" do
    u = User.create
    u.emails.create(identifier: "2#{public_email}")
    u.emails.create(identifier: "3#{public_email}")

    user = User.new

    expect(user.identify({ emails: "2#{public_email}" })).to be_persisted
    expect(user.identify({ emails: "3#{public_email}" })).to be_persisted
  end

  describe "#type" do
    it "returns the type" do
      # Add your test code here
    end
  end

  describe "#type_options" do
    it "returns the type options" do
      # Add your test code here
    end
  end

  describe "#identifiable?" do
    it "returns true if identifiable" do
      # Add your test code here
    end

    it "returns false if not identifiable" do
      # Add your test code here
    end
  end

  describe "#relation_options" do
    it "returns the relation options" do
      # Add your test code here
    end
  end

  describe "#setup_instance_methods!" do
    it "sets up instance methods" do
      # Add your test code here
    end
  end
end
