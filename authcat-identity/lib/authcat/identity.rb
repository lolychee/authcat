# frozen_string_literal: true

require 'zeitwerk'
loader = Zeitwerk::Loader.new
loader.tag = File.basename(__FILE__, '.rb')
loader.inflector = Zeitwerk::GemInflector.new(__FILE__)
loader.push_dir("#{__dir__}/..")
loader.setup

module Authcat
  module Identity
    def self.included(base)
      base.extend ClassMethods
      base.include \
        Identifier,
        Validators
    end

    module ClassMethods
      def identify(attributes)
        case attributes
        when String
          where.or(identifier_names(fuzzy_match: true).map {|name| { name => attributes } }).first
        when Hash
          where(attributes).first
        end
      end
    end
  end
end
