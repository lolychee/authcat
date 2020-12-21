# frozen_string_literal: true

module Authcat
  class Password
    module Algorithms
      extend ActiveSupport::Autoload
      extend ActiveSupport::Inflector

      def self.register(class_name)
        inflections do |inflect|
          inflect.acronym class_name.to_s
        end
        autoload class_name.to_sym, underscore("#{self}::#{class_name}")
      end

      def self.lookup(name)
        constantize("#{self}::#{camelize(name)}")
      end

      register(:BCrypt)
    end
  end
end
