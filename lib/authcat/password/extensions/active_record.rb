# frozen_string_literal: true

require "authcat/password/extensions/active_model"

module Authcat
  module Password
    module Extensions
      module ActiveRecordExtension
        if defined?(ActiveRecord) && defined?(ActiveRecord::Type)
          ActiveRecord::Type.register :password, ActiveModelExtension::PasswordType
        end
      end
    end
  end
end
