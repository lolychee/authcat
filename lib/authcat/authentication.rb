module Authcat
  module Authentication
    extend ActiveSupport::Concern

    AUTHENTICATE_HELPERS_MODULE = 'AuthenticateHelpers'

    module ClassMethods
      def authcat(name, class_name = nil, **options)
        class_name = "#{name.to_s.capitalize}Authenticator" if class_name.nil?

        klass = class_name.constantize

        const_set(AUTHENTICATE_HELPERS_MODULE, Module.new) unless const_defined?(AUTHENTICATE_HELPERS_MODULE)
        mod = const_get(AUTHENTICATE_HELPERS_MODULE)

        mod.send(:define_method, "#{name}_auth") do
          instance_variable_defined?("@#{name}_auth") ? \
            instance_variable_get("@#{name}_auth") : \
            instance_variable_set("@#{name}_auth", klass.new(request, **options))
        end

        mod.class_eval "def current_#{name}; #{name}_auth.user_or_authenticate end"

        mod.class_eval "def #{name}_signed_in?; #{name}_auth.signed_in? end"

        mod.class_eval "def authenticate_#{name}!; #{name}_auth.authenticate! end"

        include mod

        helper_method :"current_#{name}", :"#{name}_signed_in?"
      end
    end

  end
end
