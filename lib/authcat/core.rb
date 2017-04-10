module Authcat
  module Core
    extend ActiveSupport::Concern

    include Support::Configurable

    module ClassMethods
      def credential(name, klass = nil, **options, &block)
        klass ||= Credentials.lookup(name)

        credentials[name] = klass
      end

      def strategy(name, klass = nil, if: nil, unless: nil, on: nil, **options, &block)
        klass ||= Strategies.lookup(name)

        strategies[name] = ->(auth) { klass.new(auth, **options, &block) }
      end
    end

    included do
      extend Support::Registrable

      has_registry :credentials
      has_registry :strategies
    end

    attr_reader :request, :identity

    def initialize(request, **options)
      # raise ArgumentError unless request.class < Rack::Request
      config.merge!(options)

      @request = request
    end

    def strategies
      @strategies ||= self.class.strategies.map {|_, block| block[self] }
    end

    def authenticate
      strategies.select(&:exists?).each do |strategy|
        if identity = strategy.read_identity
          return @identity = identity
        end
      end
      nil
    end

    def sign_in(identity)
      strategies.reject(&:readonly?).each {|strategy| strategy.write_identity(identity) }
      @identity = identity
    end

    def signed_in?
      identity || authenticate
    end

    def sign_out
      strategies.reject(&:readonly?).each {|strategy| strategy.clear }
      @identity = nil
    end

  end
end
