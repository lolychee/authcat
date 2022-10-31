# frozen_string_literal: true

module Authcat
  module WebAuthn
    class Record < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
