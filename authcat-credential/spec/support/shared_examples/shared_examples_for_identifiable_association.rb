# frozen_string_literal: true

RSpec.shared_examples_for "identifiable reflection" do |identifiable: true|
  describe "#identify_scope" do
    it "returns the correct scope" do
      expect(subject.identify_scope(credential)).to eq(identify_scope)
    end
  end

  describe "#identify" do
    it "returns the correct record" do
      expect(identity).to be_present
      expect(subject.identify(credential)).to eq(identity)
    end
  end

  describe "#identifiable?" do
    it "returns true" do
      expect(subject.identifiable?).to eq(identifiable)
    end
  end

  describe "#extract_options!" do
    it "assigns options" do
      expect(subject.options).to include(:identify)
    end
  end
end
