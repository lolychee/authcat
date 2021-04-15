module SavedState
  extend ActiveSupport::Concern

  def saved_state
    cookies.encrypted[:saved_state] || {}
  end

  def saved_state=(data, **opts)
    cookies.encrypted[:saved_state] = {
      value: data,
      path: request.path,
      expires: 10.minutes,
      httponly: true
    }.merge(opts)
  end

  def clear_saved_state
    cookies.delete(:saved_state)
  end
end
