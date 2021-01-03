# frozen_string_literal: true

module RackMiddlewareHelper
  def mock_request(app)
    Rack::MockRequest.new(app)
  end
end
