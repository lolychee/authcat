require 'spec_helper'

describe Authcat::Core do

  let!(:authenticator_class) do
    Class.new do
      include Authcat::Core
    end
  end

  subject { authenticator_class.new(mock_request) }

  let(:user) { User.create(email: 'someone@example.com', password: 'password') }

  describe '#initialize' do

  end

  describe 'authenticate' do
    it 'should be a user' do
      subject.sign_in(user)
      expect(subject.authenticate).to eq user
    end

    it '#authenticated? be true' do
      expect {
        subject.authenticate
      }.to change(subject, :authenticated?).to(true)
    end
  end

  describe '#sign_in' do
    it 'sign in by user' do
      expect {
        subject.sign_in(user)
      }.to change(subject, :user).from(nil).to(user)
    end
  end

  describe '#sign_out' do
    before(:example) { subject.sign_in(user) }

    it '#user be nil' do
      expect {
        subject.sign_out
      }.to change(subject, :user).from(user).to(nil)
    end

    it '#authenticated? be false' do
      expect {
        subject.sign_out
      }.to change(subject, :authenticated?).to(false)
    end
  end
end
