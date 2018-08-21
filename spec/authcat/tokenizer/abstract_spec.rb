require "spec_helper"

describe Authcat::Tokenizer::Abstract do

  let!(:tokenizer_class) do
    Class.new(described_class) do |klass|
      def encode(payload)
        Base64.urlsafe_encode64(JSON.generate(payload))
      end

      def decode(token)
        JSON.parse(Base64.urlsafe_decode64(token))
      end
    end
  end

  let(:tokenizer) { tokenizer_class.new }

  let(:identity) { User.new(id: 1) }


  describe "#encode" do
    it do
      payload = {data: "data"}
      token = "eyJkYXRhIjoiZGF0YSJ9"
      expect(tokenizer.encode(payload)).to eq token
    end
  end

  describe "#decode" do
    it do
      token = "eyJ0b2tlbiI6InRva2VuIn0="
      payload = {"token" => 'token'}
      expect(tokenizer.decode(token)).to eq payload
    end
  end

end
