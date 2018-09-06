# frozen_string_literal: true

require "spec_helper"

describe Authcat::Support::Registrable do
  let(:registry_class) { described_class::Registry }

  subject { Class.new { extend Authcat::Support::Registrable } }

  describe "ClassMethods" do
    describe "#has_registry" do
      it do
        subject.has_registry
        expect(subject).to respond_to(:registry)
        expect(subject.registry).to be_a(registry_class)
      end
    end
  end

  describe "Options" do
    describe ":reader" do
      it do
        subject.has_registry reader: ->(value) { value.reverse }
        subject.registry[:key] = "abc"
        expect(subject.registry[:key]).to eq "cba"
      end
    end

    describe ":writer" do
      it do
        subject.has_registry writer: ->(value) { value * 2 }
        subject.registry[:key] = "abc"
        expect(subject.registry[:key]).to eq "abcabc"
      end
    end
  end
end
