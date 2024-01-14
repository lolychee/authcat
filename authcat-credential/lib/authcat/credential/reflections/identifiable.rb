# frozen_string_literal: true

module Authcat
  module Credential
    module Reflections
      module Identifiable
        attr_reader :identify_options

        def identify(credential)
          identify_scope(credential).first
        end

        def identify_scope(credential)
          owner.where(identify_options.fetch(:identifier, name) => credential)
        end

        def identifiable?
          options.key?(:identify) && options[:identify] != false
        end

        def extract_identify_options!(options)
          options.reverse_merge!(identify: true)
          @identify_options ||= options.fetch(:identify, {})
          @identify_options = {} unless @identify_options.is_a?(Hash)
          options
        end

        def extract_options!(*)
          extract_identify_options!(super)
        end
      end
    end
  end
end
