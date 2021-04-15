module Authentication
  extend ActiveSupport::Concern

  def current_session
    return @current_session if defined?(@current_session)
    @current_session = Session.find_signed(cookies[:access_token], purpose: :access_token)
  end

  def current_session=(session)
    if session.nil?
    cookies.delete(:access_token)
    else
      (session.remember_me ? cookies.permanent : cookies)[:access_token] = session.signed_id(purpose: :access_token)
    end
  end

  def current_user
    current_session&.user
  end

  def authenticate_user!
    if current_user.nil?
      respond_to do |format|
        format.html { redirect_to sign_in_url }
      end
    end
  end
end
