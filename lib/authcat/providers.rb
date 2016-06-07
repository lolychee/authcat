module Authcat
  module Providers
    extend ActiveSupport::Autoload
    extend ActiveSupport::Concern

    eager_autoload do
      autoload :SessionProvider
    end

    class << self
      def registry
        @registry ||= Registry.new
      end

      delegate :register, :lookup, to: :registry
    end

    module ClassMethods

      def providers
        @providers ||= []
      end

      def use(provider, **options)
        provider = Authcat::Providers.lookup(provider) unless provider.is_a?(Class)
        providers << provider.new(**options)
      end

    end

    def authenticate
      self.class.providers.each do |provider|
        provider.authenticate(self)
      end

      super
    end

    def sign_in(user)
      super

      self.class.providers.each do |provider|
        provider.sign_in(self)
      end
    end

    def sign_out
      super

      self.class.providers.each do |provider|
        provider.sign_out(self)
      end
    end

    eager_load!
  end
end
