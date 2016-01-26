require 'spec_helper'

describe Authcat::Callbacks do

  class TestCallbacksAuthenticator
    module Core
      def history
        @history ||= []
      end

      def authenticate
        self.history << :authenticate
      end
    end

    include Core
    include Authcat::Callbacks

    set_callback :authenticate, :before do
      self.history << :before_authenticate
    end
    set_callback :authenticate, :after do
      self.history << :after_authenticate
    end
    set_callback :authenticate, :around do |r, block|
      self.history << :before_around_authenticate
      block.call
      self.history << :after_around_authenticate
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
    TestCallbacksAuthenticator.before_authenticate do
      self.history << :before_authenticate_via_helper
    end
    authenticator = TestCallbacksAuthenticator.new
    authenticator.authenticate
    expect(authenticator.history).to include :before_authenticate_via_helper
  end

end
