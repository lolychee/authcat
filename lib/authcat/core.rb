module Authcat
  module Core
    extend ActiveSupport::Concern

    include Authcat::Options::Optionable

    def initialize(request, **options)
      raise ArgumentError unless request.is_a?(Rack::Request)
      @request = request

      apply_options(options)
    end

    def apply_options(options)
      super
      authenticate if options[:preload]
    end

    def request
      @request
    end

    def user
      @user
    end

    def user=(user)
      unless user.nil?
        raise ArgumentError unless user.is_a?(Authcat::Model)
        raise ArgumentError if user.new_record?
      end

      @user = user
    end

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
      authenticate unless authenticated?
      !user.nil?
    end

    def sign_out
      @authenticated = false
      self.user = nil
    end

  end
end
