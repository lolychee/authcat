module Authcat
  module Core
    extend ActiveSupport::Concern

    include Support::Configurable

    def initialize(request, **options)
      # raise ArgumentError unless request.is_a?(Rack::Request)
      @request = request

      config.merge!(options)
    end

    attr_reader :request, :identity

    def identity=(identity)
      unless identity.nil?
        raise ArgumentError, "identity should be ActiveRecord::Base instance and presisted." unless identity.is_a?(ActiveRecord::Base) && identity.persisted?
      end

      @identity = identity
    end

    def identity_or_authenticate
       authenticate unless authenticated?
       identity
    end

    def authenticate
      @authenticated = true
      identity
    end

    def authenticate!
      authenticate || raise(IdentityNotFound)
    end

    def authenticated?
      @authenticated
    end

    def sign_in(identity)
      self.identity = identity
    end

    def signed_in?
      !identity_or_authenticate.nil?
    end

    def sign_out
      self.identity = nil
    end

  end
end
