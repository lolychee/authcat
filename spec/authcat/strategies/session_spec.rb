require "spec_helper"

describe Authcat::Strategies::Session do

  let(:identity) { User.create(email: "test@example.com", password: "123456") }

  let(:auth) { Authcat::Authenticator.new(mock_request) }

  let(:request) { auth.request }

  let(:key) { :token }

  let(:credential) { credential_class.create(identity) }

  let(:credential_class) { Authcat::Credentials::GlobalID }

  subject { described_class.new(auth, key: key, using: credential_class) }

  describe "#read" do
    context "when session[key] is nil" do
      it "should eq nil" do
        expect(subject.read).to eq nil
      end
    end

    context "when session[key] is valid" do
      it "should be a identity" do
        request.session[key] = credential.to_s
        expect(subject.read).to be_a(Authcat::Credentials::Abstract)
      end
    end

    context "when session[key] is invalid" do
      it "should raise Authcat::Errors::InvalidCredential" do
        request.session[key] = "invalid value"
        expect {
          subject.read
        }.to raise_error(Authcat::Errors::InvalidCredential)
      end
    end
  end

  describe "#write" do
    context "when given a user" do
      it "session[key] equal credential" do
        expect {
          subject.write(credential)
        }.to change { request.session[key] }
      end
    end
  end

  describe "#clear" do
    context "when given a nil" do
      it "delete session[key]" do
        request.session[key] = "token"
        expect {
          subject.clear
        }.to change { request.session.key?(key) }.to(false)
      end
    end
  end

  describe "#exists?" do
    context "when session[key] is blank" do
      it "should be false" do
        expect(subject).not_to be_exists
      end
    end

    context "when session[key] is not blank" do
      it "should be true" do
        request.session[key] = "token"
        expect(subject).to be_exists
      end
    end
  end

  describe "#readonly?" do
    it "should be false" do
      expect(subject).not_to be_readonly
    end
  end

end
