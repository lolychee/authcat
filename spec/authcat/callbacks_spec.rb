require 'spec_helper'

describe Authcat::Callbacks do

  let!(:authenticator_class) do
    Class.new do
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
  end

  let!(:callback_helper_authenticator_class) do
    Class.new(authenticator_class) do
      before_authenticate do
        history << :before_authenticate_via_helper
      end
    end
  end

  it 'finish callbacks chain' do
    callbacks_chain = %i[
      before_authenticate
      before_around_authenticate
      authenticate
      after_around_authenticate
      after_authenticate
    ]
    authenticator = authenticator_class.new
    authenticator.authenticate
    expect(authenticator.history).to eq callbacks_chain
  end

  it 'set callback with helper method' do
    authenticator = callback_helper_authenticator_class.new
    authenticator.authenticate
    expect(authenticator.history).to include :before_authenticate_via_helper
  end

end
