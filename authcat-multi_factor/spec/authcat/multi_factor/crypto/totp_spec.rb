# frozen_string_literal: true

RSpec.describe Authcat::MultiFactor::Crypto::TOTP do
  let(:crypto) { described_class.new }
  let(:validator) do
    lambda { |ciphertext|
      begin
        ::ROTP::Base32.decode(ciphertext) && true
      rescue StandardError
        false
      end
    }
  end

  describe "#generate" do
    context "with default byte_length" do
      it "is valid hash string" do
        ciphertext = crypto.generate
        expect(validator.call(ciphertext)).to eq true
      end
    end

    context "with custom byte_length" do
      let(:length) { 30 }

      it "is valid hash string" do
        ciphertext = crypto.generate(length)
        expect(validator.call(ciphertext)).to eq true
      end
    end
  end

  describe "#verify" do
    let(:ciphertext) { "MCRVVCCEN2EAZ7MG3IYLRRCKMYNPAUI3" }
    let(:otp) { ::ROTP::TOTP.new(ciphertext) }

    it "verify at now" do
      expect(crypto.verify(ciphertext, otp.now)).to eq true
    end

    it "verify at sometimes" do
      timestamp = Time.at(1_000_000_000)
      expect(crypto.verify(ciphertext, otp.at(timestamp), at: timestamp)).to eq true
    end

    it "verify with block" do
      timestamp = Time.at(1_000_000_000)
      expect(crypto.verify(ciphertext, otp.at(timestamp), at: timestamp) do |t|
               expect(t).to eq Time.at(999_999_990)
             end).to eq true
    end
  end
end
