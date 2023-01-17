# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  include ExtraAction

  self.abstract_class = true
end
