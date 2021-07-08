# frozen_string_literal: true

RSpec.shared_examples "a crypto" do
  let(:crypto) { described_class.new }
  let(:validator) { ->(_ciphertext) { false } }

  describe "#generate" do
    context "with empty string" do
      let(:password) { "" }

      it "is valid hash string" do
        ciphertext = crypto.generate(password)
        expect(validator.call(ciphertext)).to eq true
      end
    end

    context "with number string" do
      let(:password) { "12345678" }

      it "is valid hash string" do
        ciphertext = crypto.generate(password)
        expect(validator.call(ciphertext)).to eq true
      end
    end
  end
end
