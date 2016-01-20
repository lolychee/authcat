module Authcat
  module Validations

    def validate
      errors.clear
      run_callbacks(:validate)
      errors.empty?
    end

    alias_method :valid?, :validate

    def validate!
      validate or raise_validation_error
    end

  end
end
