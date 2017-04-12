require "spec_helper"

describe Authcat::Strategies::Cookies do
  let(:identity) { User.create(email: "test@example.com", password: "123456") }

  let(:auth) { Authcat::Authenticator.new(mock_request) }

  let(:request) { auth.request }

  let(:key) { :token }

  let(:credential) { credential_class.create(identity) }

  let(:credential_class) { Authcat::Credentials::GlobalID }

  subject { described_class.new(auth, key: key, using: credential_class) }

  describe "#read" do
    context "when cookies[key] is nil" do
      it "should be nil" do
        expect(subject.read).to eq nil
      end
    end

    context "when cookies[key] is valid" do
      it "should be a identity" do
        request.cookie_jar[key] = credential.to_s
        subject.encrypted = false
        expect(subject.read).to be_a(Authcat::Credentials::Abstract)
      end
    end

    context "when cookies[key] is invalid" do
      it "should raise Authcat::Errors::InvalidCredential" do
        request.cookie_jar[key] = "invalid value"
        expect {
          subject.read
        }.to raise_error(Authcat::Errors::InvalidCredential)
      end
    end
  end

  describe "#write" do
    context "when given a identity" do
      it "cookies[key] equal credential" do
        expect {
          subject.write(credential)
        }.to change { request.cookie_jar[key] }
      end
    end
  end

  describe "#clear" do
    context "when given a nil" do
      it "delete cookies[key]" do
        request.cookie_jar[key] = "token"
        expect {
          subject.clear
        }.to change { request.cookie_jar.key?(key) }.to(false)
      end
    end
  end

  describe "#cookies" do
    context "when encrypted: true" do
      it "should be ActionDispatch::Cookies::EncryptedCookieJar instance" do
        subject.encrypted = true
        expect(subject.cookies).to be_a(ActionDispatch::Cookies::EncryptedCookieJar)
      end
    end

    context "when signed: true" do
      it "should be ActionDispatch::Cookies::PermanentCookieJar instance" do
        subject.encrypted = false
        subject.signed = true
        expect(subject.cookies).to be_a(ActionDispatch::Cookies::SignedCookieJar)
      end
    end

    context "when permanent: true" do
      it "should be ActionDispatch::Cookies::PermanentCookieJar instance" do
        subject.encrypted = false
        subject.permanent = true
        expect(subject.cookies).to be_a(ActionDispatch::Cookies::PermanentCookieJar)
      end
    end
  end

  describe "#exists?" do
    context "when cookies[key] is nil" do
      it "should be false" do
        expect(subject).not_to be_exists
      end
    end

    context "when cookies[key] is not nil" do
      it "should be true" do
        request.cookie_jar[key] = "token"
        expect(subject).to be_present
      end
    end
  end

  describe "#readonly?" do
    it "should be false" do
      expect(subject).not_to be_readonly
    end
  end

end
