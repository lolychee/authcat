# frozen_string_literal: true

module Authentication
  extend ActiveSupport::Concern

  included do |controller|
    controller.around_action :authenticate_session
    controller.helper_method :current_user
  end

  def authenticate_session
    Current.session = UserSession.find_signed(cookies[:access_token], purpose: :access_token)

    yield

    if Current.session.nil? || Current.session.destroyed?
      cookies.delete(:access_token)
    elsif Current.session.persisted? && Current.session.previously_new_record?
      (Current.session.remember_me ? cookies.permanent : cookies)[:access_token] =
        Current.session.signed_id(purpose: :access_token)
    end
  end

  def current_user
    Current.user
  end

  def current_session
    Current.session
  end

  def authenticate_user!
    return unless current_user.nil?

    respond_to do |format|
      format.html { redirect_to sign_in_url }
    end
  end
end
