# frozen_string_literal: true

require "authcat/extensions/active_model"

module Authcat
  module Extensions
    module ActiveRecordExtension
      if defined?(ActiveRecord) && defined?(ActiveRecord::Type) && defined?(ActiveRecord::Base)
        ActiveRecord::Type.register :password, ActiveModelExtensions::PasswordType
      end
    end
  end
end
