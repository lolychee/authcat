# frozen_string_literal: true

RSpec.shared_examples "an engine" do
  let(:engine) { described_class }
  let(:validator) { ->(_ciphertext) { false } }

  describe "#create" do
    context "with empty string" do
      let(:password) { "" }

      it "is valid hash string" do
        ciphertext = engine.create(password)
        expect(validator.call(ciphertext)).to be true
        expect(engine.verify(password, ciphertext)).to be true
      end
    end

    context "with number string" do
      let(:password) { "12345678" }

      it "is valid hash string" do
        ciphertext = engine.create(password)
        expect(validator.call(ciphertext)).to be true
        expect(engine.verify(password, ciphertext)).to be true
      end
    end
  end
end
