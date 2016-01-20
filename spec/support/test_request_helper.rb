require 'action_dispatch'

module TestRequestHelper
  def mock_request(*args)
    ActionDispatch::TestRequest.new(*args)
  end
end
