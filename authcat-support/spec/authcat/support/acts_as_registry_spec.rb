# frozen_string_literal: true

RSpec.describe Authcat::Support::ActsAsRegistry do
  subject(:registry_class) { Class.new { include Authcat::Support::ActsAsRegistry } }

  let(:key) { :foo }
  let(:value) { "bar" }

  describe ".registry" do
    it "returns a Dry::Container instance" do
      expect(registry_class.registry).to be_a(Dry::Container)
    end
  end

  describe ".register" do
    it "registers a key-value pair in the registry" do
      registry_class.register(key, value)
      expect(registry_class.registry.resolve(key)).to eq(value)
    end
  end

  describe ".resolve" do
    it "resolves a value from the registry" do
      registry_class.register(key, value)
      expect(registry_class.resolve(key)).to eq(value)
    end

    context "when a block is given" do
      it "yields the resolved value to the block" do
        registry_class.register(key, value)
        expect { |block| registry_class.resolve(key, &block) }.to yield_with_args(value)
      end
    end
  end
end
