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

  describe '.create' do
    it do
      expect(Reverse.create(password)).to eq password.reverse
    end
  end

end
