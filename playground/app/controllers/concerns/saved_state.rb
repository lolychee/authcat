# frozen_string_literal: true

module SavedState
  extend ActiveSupport::Concern

  def with_saved_state(record, scope: :saved_state, expires: 10.minutes, setter: :attributes=, getter: :attributes)
    saved_state = cookies.encrypted[scope]
    record.send(setter, saved_state) if saved_state

    yield

    saved_state = record.send(getter)
    if saved_state.nil?
      cookies.delete(scope, path: request.path)
    else
      cookies.encrypted[scope] = {
        value: saved_state,
        path: request.path,
        expires: expires,
        httponly: true
      }
    end
  end
end
