# frozen_string_literal: true

RSpec.shared_examples "an algorithm" do
  let(:algorithm) { described_class.new }
  let(:validator) { ->(_ciphertext) { false } }

  describe "#digest" do
    context "with empty string" do
      let(:password) { "" }

      it "is valid hash string" do
        ciphertext = algorithm.digest(password)
        expect(validator.call(ciphertext)).to eq true
      end
    end
  end
end
