module Authcat
  module Strategies
    extend ActiveSupport::Autoload
    extend ActiveSupport::Concern

    autoload :Base
    autoload :Debug
    autoload :Session

    SHORT_NAME_MAP = {
      session: 'Session'
    }.with_indifferent_access

    def self.const_get(name)
      if SHORT_NAME_MAP.key?(name)
        super(SHORT_NAME_MAP[name])
      else
        super
      end
    end

    module ClassMethods
      def strategies
        @strategies ||= []
      end

      def use(strategy_name, **options)
        strategy_klass = Strategies.const_get(strategy_name) if strategy_name.is_a?(Symbol) || strategy_name.is_a?(String)

        strategy = strategy_klass.new(**options)
        yield strategy if block_given?

        strategies << strategy
      end
    end

    def authenticate
      self.class.strategies.each do |strategy|
        next unless strategy.has_credential?(request)
        if user = strategy.find_user(request)
          self.user = user
          break
        end
      end

      super
    end

    def sign_in(user)
      self.class.strategies.each do |strategy|
        next if strategy.readonly?
        strategy.save_user(request, user)
      end

      super
    end

    def sign_out
      self.class.strategies.each do |strategy|
        next if strategy.readonly? || !strategy.has_credential?(request)
        strategy.save_user(request, nil)
      end

      super
    end

  end
end
