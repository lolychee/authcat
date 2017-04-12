require "spec_helper"

describe Authcat::Railtie do
  describe "initializer" do
    it do
      expect(ActionController::Base).to include(Authcat::Railtie::ControllerMixin)
    end
  end

  describe Authcat::Railtie::ControllerMixin do
    let(:controller_class) do
      Class.new(ActionController::Base) do
        extend Authcat::Railtie::ControllerMixin
      end
    end

    subject { controller_class.new }

    describe ".authcat" do
      context "when given a :user" do
        before(:example) { controller_class.authenticator :user }

        it "respond to #authenticator" do
          expect(subject).to respond_to(:authenticator)
        end

        it "respond to #current_user" do
          expect(subject).to respond_to(:current_user)
        end

        it "respond to #signed_in?" do
          expect(subject).to respond_to(:signed_in?)
        end

        it "respond to #authenticate_user!" do
          expect(subject).to respond_to(:authenticate_user!)
        end

        it "#current_user and #signed_in? is helper method" do
          expect(subject._helper_methods).to include(:current_user, :signed_in?)
        end
      end
    end

  end
end
