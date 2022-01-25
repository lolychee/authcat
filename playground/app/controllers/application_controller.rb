class ApplicationController < ActionController::Base
  include Authentication
  include SavedState

  rescue_from(ActionController::RoutingError) do
    render :not_found, status: :not_found
  end
end
