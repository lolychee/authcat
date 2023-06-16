# frozen_string_literal: true

module Authcat
  module Password
    module Record
      extend ActiveSupport::Concern
      include Password

      included do
      end
    end
  end
end
