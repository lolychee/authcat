require 'action_dispatch'

module TestRequestHelper
  def mock_request(*args)
    ActionDispatch::TestRequest.create(*args)
  end
end
