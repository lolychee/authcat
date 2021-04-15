class ApplicationController < ActionController::Base
  include Authentication
  include SavedState
end
