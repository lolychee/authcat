module Authcat
  module Strategies
    extend ActiveSupport::Autoload
    extend ActiveSupport::Concern

    extend Support::Registrable

    autoload :Abstract
    autoload :Base
    autoload :Debug
    autoload :Session
    autoload :Cookies

    register :debug,    :Debug
    register :session,  :Session
    register :cookies,  :Cookies

    def self.lookup(name)
      super do |value|
        value.is_a?(Class) ? value : const_get(value)
      end
    end

    module ClassMethods
      def strategies
        @strategies ||= []
      end

      def use(name, if: nil, unless: nil, on: nil, **options, &block)
        strategy = name.is_a?(Class) ? name : Strategies.lookup(name)

        strategies << proc {|request| strategy.new(request, **options, &block) }
      end
    end

    included do
      option :scope, :default
    end

    def strategies(**options)
      @strategies ||= self.class.strategies.map {|block| block.(self) }

      list = @strategies.dup
      options.each do |name, boolean|
        list.send(boolean ? :select! : :reject!, &:"#{name}?")
      end
      list
    end

    def authenticate
      strategies(exists: true).each do |strategy|
        strategy.authenticate do |identity|
          self.identity = identity
          break
        end
      end

      super
    end

    def sign_in(identity)
      result = super
      strategies(readonly: false).each {|strategy| strategy.sign_in }

      result
    end

    def sign_out
      result = super
      strategies(readonly: false, exists: true).each {|strategy| strategy.sign_out }

      result
    end

  end
end
