# frozen_string_literal: true

RSpec.shared_examples_for "base reflection" do
  describe "#initialize" do
    it "assigns owner" do
      expect(subject.owner).to eq(owner)
    end

    it "assigns name" do
      expect(subject.name).to eq(name)
    end

    it "assigns options" do
      expect(subject.options).to be_a(Hash)
    end

    it "assigns block" do
      expect(subject.instance_variable_get(:@block)).to eq(block)
    end
  end

  describe "#extract_options!" do
    it "assigns options" do
      expect(subject.options).to include(options)
    end
  end

  describe "#setup!" do
    it "raises NotImplementedError" do
      expect { subject.setup! }.not_to raise_error
    end
  end
end
