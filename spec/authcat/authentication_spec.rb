require 'spec_helper'

describe Authcat::Authentication do

  let(:controller_class) do
    Class.new(ActionController::Base) do
      include Authcat::Authentication
    end
  end

  subject { controller_class.new }

  describe '.authcat' do
    context 'when gevin a :user' do
      before(:example) { controller_class.authcat :user }

      it 'respond to #user_auth' do
        expect(subject).to respond_to(:user_auth)
      end

      it 'respond to #current_user' do
        expect(subject).to respond_to(:current_user)
      end

      it 'respond to #user_signed_in?' do
        expect(subject).to respond_to(:user_signed_in?)
      end

      it 'respond to #authenticate_user!' do
        expect(subject).to respond_to(:authenticate_user!)
      end

      it '#current_user and #user_signed_in? is helper method' do
        expect(subject._helper_methods).to include(:current_user, :user_signed_in?)
      end
    end
  end
end
