# frozen_string_literal: true

class Session < ActiveRecord::Base
  belongs_to :user
end
