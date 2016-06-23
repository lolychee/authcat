require 'spec_helper'

describe Authcat::Railtie do
  describe 'initializer' do
    it do
      expect(ActionController::Base).to include(Authcat::Authentication)
    end
  end
end
