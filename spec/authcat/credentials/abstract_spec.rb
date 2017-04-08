require 'spec_helper'

describe Authcat::Credentials::Abstract do

  let!(:credential_class) do
    Class.new(described_class) do |klass|

      def klass.valid?(raw_data)
        raw_data =~ /^\w+:[0-9]+$/
      end

      def _update(identity)
        @raw_data = [identity.class.name, identity.id].join(':')
      end

      def find
        klass, id = raw_data.split(':')
        klass.constantize.find(id)
      end
    end
  end

  let(:credential) { credential_class.create(identity) }

  let(:identity) { User.new(id: 1) }

  describe '.create' do
    context 'when given a identity' do
      it 'should be a credential' do
        expect(credential_class.create(identity)).to be_a(credential_class)
      end
    end
  end

  describe '.valid?' do
    it 'should raise NotImplementedError' do
      expect {
        described_class.valid?('')
      }.to raise_error(NotImplementedError)
    end
  end

  describe '#initialize' do
    context 'when given a valid credential' do
      it 'should replace with valid credential' do
        expect(credential_class.new('User:1').to_s).to eq 'User:1'
      end
    end
  end

  describe '#update' do
    context 'when given a identity' do
      it 'should update to new credential' do
        new_identity = User.new(id: 2)
        expect(credential.update(new_identity).to_s).to eq 'User:2'
      end
    end
  end

  describe '#find' do
    it 'should raise NotImplementedError' do
      expect {
        described_class.new.find
      }.to raise_error(NotImplementedError)
    end
  end

end
