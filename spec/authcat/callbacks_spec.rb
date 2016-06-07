require 'spec_helper'

describe Authcat::Callbacks do

  class TestCallbacksAuthenticator
    module Core
      def history
        @history ||= []
      end

      def authenticate
        history << :authenticate
      end
    end

    include Core
    include Authcat::Callbacks

    set_callback :authenticate, :before do
      history << :before_authenticate
    end
    set_callback :authenticate, :after do
      history << :after_authenticate
    end
    set_callback :authenticate, :around do |r, block|
      history << :before_around_authenticate
      block.call
      history << :after_around_authenticate
    end

  end

  class TestCallbackHelperAuthenticator < TestCallbacksAuthenticator
    before_authenticate do
      history << :before_authenticate_via_helper
    end
  end

  it '完成回调链' do
    callbacks_chain = %i[
      before_authenticate
      before_around_authenticate
      authenticate
      after_around_authenticate
      after_authenticate
    ]
    authenticator = TestCallbacksAuthenticator.new
    authenticator.authenticate
    expect(authenticator.history).to eq callbacks_chain
  end

  it '通过快捷类方法添加回调' do
    authenticator = TestCallbackHelperAuthenticator.new
    authenticator.authenticate
    expect(authenticator.history).to include :before_authenticate_via_helper
  end

end
