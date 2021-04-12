module SignIn
  extend ActiveSupport::Concern

  def tfa_user
    user = User.find_signed(session[:tfa_user_id])
    user if session[:tfa_user_checksum] == tfa_user_checksum(user)
  end

  def tfa_user=(user)
    session[:tfa_user_id] = user.signed_id(expires_in: 5.minutes, purpose: :tfa)
    session[:tfa_user_checksum] = tfa_user_checksum(user)
  end

  def tfa_user_checksum(user)
    user && Digest::SHA256.hexdigest(user.slice(:password_digest).to_json)
  end
end
