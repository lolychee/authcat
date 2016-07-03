module Authcat
  module Strategies
    extend ActiveSupport::Autoload
    extend ActiveSupport::Concern

    extend Support::Registrable

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
        @strategies ||= Hash.new {|hash, key| hash[key] = [] }
      end

      def use(name, **options)
        strategy = (name.is_a?(Class) ? name : Strategies.lookup(name))[**options]

        yield strategy if block_given?

        strategies[@scope] << strategy
      end

      def scope(name)
        @scope, old = name, @scope
        yield if block_given?
        @scope = old
      end
    end

    included do
      option :scope, nil, class_accessor: false
    end

    def strategies(**options)
      @strategies ||= self.class.strategies[self.scope].map {|klass| klass.new(request) }

      list = @strategies.dup
      options.each do |name, boolean|
        list.send(boolean ? :select! : :reject!, &:"#{name}?")
      end
      list
    end

    def authenticate
      self.user = catch :success do
        strategies(present: true).each {|strategy| strategy.authenticate }
        nil
      end

      super
    end

    def sign_in(user)
      strategies(readonly: false).each {|strategy| strategy.sign_in(user) }

      super
    end

    def sign_out
      strategies(readonly: false, present: true).each {|strategy| strategy.sign_out }

      super
    end

  end
end
