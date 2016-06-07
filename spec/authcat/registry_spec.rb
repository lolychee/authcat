require 'spec_helper'

describe Authcat::Registry do

  describe '#[]=' do
    it 'add an item' do
      subject.register(:array, Array)
      expect(subject[:array]).to eq Array
    end

    it 'raise AlreadyExists if key already exists' do
      subject.register(:array, Array)
      expect {
        subject.register(:array, Array)
      }.to raise_error(described_class::AlreadyExists)
    end

    it 'raise TypeError if given wrong type' do
      expect {
        described_class.new(Array).register(:wrong_type, {})
      }.to raise_error(described_class::TypeError)
    end
  end

  describe '#[]' do
    it 'return value' do
      subject.register(:array, Array)
      expect(subject[:array]).to eq Array
    end

    it 'raise NotFound if key not exists' do
      expect{
        subject[:array]
      }.to raise_error(described_class::NotFound)
    end
  end


end
