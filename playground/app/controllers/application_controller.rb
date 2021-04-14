class ApplicationController < ActionController::Base
  include Authentication
  include Encryptor
end
