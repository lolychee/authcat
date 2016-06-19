module Authcat
  module Core
    extend ActiveSupport::Concern

    include Support::Configurable

    def initialize(request, **options)
      raise ArgumentError unless request.is_a?(Rack::Request)
      @request = request

      config.merge!(options)
    end

    attr_reader :request
    attr_accessor :user

    def authenticate
      @authenticated = true
      user
    end

    def authenticate!
      authenticate || raise(Unauthenticated)
    end

    def authenticated?
      @authenticated
    end

    def sign_in(user)
      self.user = user
    end

    def signed_in?
      !user.nil?
    end

    def sign_out
      @authenticated = false
      self.user = nil
    end

  end
end
