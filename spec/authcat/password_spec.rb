require 'spec_helper'

describe Authcat::Password do

  class Reverse < described_class

    def self.valid?(password)
      true
    end

    private

      def hash(password)
        password.reverse
      end
  end

  let(:password) { 'password' }

  describe '.registry' do
    it 'return a registry' do
      expect(described_class.registry).to be_an_instance_of(Authcat::Registry)
    end
  end

  describe '.create' do
    it do
      expect(Reverse.create(password)).to eq password.reverse
    end
  end

end
