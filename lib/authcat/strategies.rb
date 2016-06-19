module Authcat
  module Strategies
    extend ActiveSupport::Autoload
    extend ActiveSupport::Concern

    extend Support::Registrable

    eager_autoload do
      autoload :Base
      autoload :Debug
      autoload :Session
    end

    module ClassMethods
      def strategies
        @strategies ||= Authcat::Registry.new
      end

      def use(strategy, **options)
        strategy = Strategies.lookup(strategy) unless strategy.is_a?(Class)

        key = options[:as] || strategy.name

        strategies[key] = strategy.new(**options)
        yield strategies[key] if block_given?
      end
    end

    def authenticate
      self.class.strategies.each_value do |strategy|
        next unless strategy.has_credential?(request)
        if user = strategy.find_user(request)
          self.user = user
          break
        end
      end

      super
    end

    def sign_in(user)
      self.class.strategies.each_value do |strategy|
        next if strategy.readonly?
        strategy.save_user(request, user)
      end

      super
    end

    def sign_out
      self.class.strategies.each_value do |strategy|
        next if strategy.readonly? || !strategy.has_credential?(request)
        strategy.save_user(request, nil)
      end

      super
    end

    eager_load!
  end
end
