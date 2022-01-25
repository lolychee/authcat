class HomeController < ApplicationController
  def index
  end

  def not_found
    render :not_found, status: :not_found
  end
end
