# frozen_string_literal: true

require "active_model/validator"

module Authcat
  module Identity
    module Validators
      class IdentifyValidator < ActiveModel::EachValidator
        def validate_each(record, attribute, value)
          identity = case options[:with]
                     when String, Symbol
                       record.public_send("build_#{options[:with]}") do |id|
                         id.identify({ attribute => value }, **options.slice(:only, :except))
                       end
                     else
                       record.identify({ attribute => value }, **options.slice(:only, :except))
                     end

          record.errors.add(attribute, :not_found, **options.slice(:message)) unless identity.persisted?
        end
      end
    end
  end
end
