module Authcat
  module Core
    extend ActiveSupport::Concern

    include Authcat::Options::Optionable

    module ClassMethods

      def providers
        @providers ||= []
      end

      def use(provider, **options)
        provider = Authcat::Providers.lookup(provider) unless provider.is_a?(Class)
        providers << provider.new(**options)
      end

    end

    def initialize(request, **options)
      @request = request
      apply_options(options)
    end

    def request
      @request
    end

    def authenticate

    end

    def sign_in(session, **options)
      # raise ArgumentError unless session.is_a?(Authcat::Session)
      if session.present?
        run_providers do |provider|
          provider.set_auth_hash(request, user_session.to_auth_hash)
        end

        @session = session
      else
        false
      end
    end

    def sign_out
      session.try(:destroy)
    end

    def session
      @session
    end

    def user
      session.try(:user)
    end


    private

    def run_providers(**options, &block)
      self.class.providers.each(&block)
    end


  end
end
