require 'spec_helper'

describe Authcat::Core do

  let!(:authenticator_class) do
    Class.new do
      include Authcat::Core
    end
  end

  subject { authenticator_class.new(mock_request) }

  let(:identity) { User.create(email: 'someone@example.com', password: 'password') }

  describe '#initialize' do

  end

  describe 'authenticate' do
    it 'should be a identity' do
      subject.sign_in(identity)
      expect(subject.authenticate).to eq identity
    end

    it '#authenticated? be true' do
      expect {
        subject.authenticate
      }.to change(subject, :authenticated?).to(true)
    end
  end

  describe '#sign_in' do
    it 'sign in by identity' do
      expect {
        subject.sign_in(identity)
      }.to change(subject, :identity).from(nil).to(identity)
    end
  end

  describe '#sign_out' do
    before(:example) { subject.sign_in(identity) }

    it '#identity be nil' do
      expect {
        subject.sign_out
      }.to change(subject, :identity).from(identity).to(nil)
    end
  end
end
