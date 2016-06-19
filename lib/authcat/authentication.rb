module Authcat
  module Authentication
    extend ActiveSupport::Concern

    module ClassMethods
      def authcat(name, class_name = nil, **options)
        class_name = "#{name.to_s.capitalize}Authenticator" if class_name.nil?

        class_eval <<-METHOD
          def #{name}_auth
            @#{name}_auth ||= #{class_name}.new(request)
          end
        METHOD

        class_eval <<-METHOD
          def #{name}_signed_in?
            !current_#{name}.nil?
          end
        METHOD

        class_eval <<-METHOD
          def current_#{name}
            #{name}_auth.authenticate unless #{name}_auth.authenticated?
            #{name}_auth.user
          end
        METHOD

        class_eval <<-METHOD
          def authenticate_#{name}!
            #{name}_auth.authenticate!
          end
        METHOD

        helper_method "current_#{name}", "#{name}_signed_in?"
      end
    end

  end
end
