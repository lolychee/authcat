# frozen_string_literal: true

require "active_model/validator"

module Authcat
  module Authenticator
    module Validators
      class IdentifyValidator < ActiveModel::EachValidator
        def validate_each(record, attribute, value)
          identity = case options[:with]
                     when String, Symbol
                       record.public_send(:"build_#{options[:with]}") do |id|
                         id.identify({ attribute => value }, **options.slice(:only, :except))
                       end
                     else
                       record.identify({ attribute => value }, **options.slice(:only, :except))
                     end

          record.errors.add(attribute, :not_found, **options.slice(:message)) unless identity.persisted?
        end

        def identity_reload!(record, found)
          record.instance_eval do
            if instance_variable_defined?(:@association_cache)
              @association_cache = found.instance_variable_get(:@association_cache)
            end
            @attributes = found.instance_variable_get(:@attributes)
            @new_record = false
            @previously_new_record = false if instance_variable_defined?(:@previously_new_record)
          end

          record
        end
      end
    end
  end
end
