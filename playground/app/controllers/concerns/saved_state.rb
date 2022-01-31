# frozen_string_literal: true

module SavedState
  extend ActiveSupport::Concern

  def with_saved_state(record, scope: :saved_state, expires: 10.minutes, setter: :from_json, getter: :to_json, **opts)
    if (opts.key?(:if) ? record.send(opts[:if]) : true) && (opts.key?(:unless) ? !record.send(opts[:unless]) : true) && cookies.key?(scope)
      saved_state = cookies.encrypted[scope]
      record.send(setter, saved_state)
    end

    yield

    if (opts.key?(:if) ? record.send(opts[:if]) : true) && (opts.key?(:unless) ? !record.send(opts[:unless]) : true)
      saved_state = record.send(getter)
      cookies.encrypted[scope] = {
        value: saved_state,
        path: request.path,
        expires: expires,
        httponly: true
      }
    else
      cookies.delete(scope, path: request.path)
    end
  end
end
