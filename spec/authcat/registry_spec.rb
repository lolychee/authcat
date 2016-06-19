require 'spec_helper'

describe Authcat::Registry do

  describe '#register' do
    it 'add an item' do
      subject.register(:array, Array)
      expect(subject.lookup(:array)).to eq Array
    end

    it 'raise AlreadyExists if key already exists' do
      subject.register(:array, Array)
      expect {
        subject.register(:array, Array)
      }.to raise_error(described_class::AlreadyExists)
    end
  end

  describe '#lookup' do
    it 'return value' do
      subject.register(:array, Array)
      expect(subject.lookup(:array)).to eq Array
    end

    it 'raise NotFound if key not exists' do
      expect{
        subject.lookup(:array)
      }.to raise_error(described_class::NotFound)
    end
  end

end
