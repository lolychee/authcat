# frozen_string_literal: true

module Authcat
  module Password
    module Type
      class Digest < Password
        # @return [Symbol, String, self]
        class_attribute :default_algorithm
        self.default_algorithm = :bcrypt

        def initialize(cast_type, **options)
          options[:algorithm] ||= default_algorithm
          super(cast_type, **options)
        end

        def encoder
          @encoder ||= Encoder.new(Algorithm.resolve(options.delete(:algorithm)), **options)
        end
      end
    end
  end
end
