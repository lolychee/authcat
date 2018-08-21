require "action_dispatch"

module TestRequestHelper
  def mock_request(*args)
    Rack::MockRequest.new(*args)
  end
end
