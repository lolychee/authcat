# frozen_string_literal: true

RSpec.shared_examples 'an algorithm' do
  let(:algorithm) { described_class.new }

  describe '#digest' do
    context 'with empty string' do
      let(:password) { '' }

      it 'is valid hash string' do
        encrypted_str = algorithm.digest(password)
        expect(BCrypt::Password.valid_hash?(encrypted_str)).to eq true
      end
    end
  end
end
