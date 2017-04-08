module Authcat
  module Strategies
    extend ActiveSupport::Autoload
    extend ActiveSupport::Concern

    autoload :Abstract
    autoload :Base
    autoload :Debug
    autoload :Session
    autoload :Cookies

    extend Support::Registrable
    has_registry reader: ->(value) { value.is_a?(Class) ? value : Authcat::Strategies.const_get(value) }

    extend SingleForwardable
    def_delegators :registry, :register, :lookup

    register :debug,    :Debug
    register :session,  :Session
    register :cookies,  :Cookies

    module ClassMethods

      def use(name, if: nil, unless: nil, on: nil, **options, &block)
        strategy = name.is_a?(Class) ? name : Strategies.lookup(name)

        strategies << proc {|request| strategy.new(request, **options, &block) }
      end
    end

    included do
      has_registry :strategies

      option :scope, :default
    end

    # def strategies(**options)
    #   @strategies ||= self.class.strategies.map {|block| block.(self) }
    #
    #   list = @strategies.dup
    #   options.each do |name, boolean|
    #     list.send(boolean ? :select! : :reject!, &:"#{name}?")
    #   end
    #   list
    # end

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
