require 'spec_helper'

describe Authcat::Digest do

  class Reverse < Authcat::Digest

    def self.valid?(password)
      true
    end

    private

      def _hash(password)
        password.reverse
      end
  end

  let(:password) { 'password' }

  describe '.digest' do
    it do
      expect(Reverse.digest(password)).to eq password.reverse
    end
  end

end
