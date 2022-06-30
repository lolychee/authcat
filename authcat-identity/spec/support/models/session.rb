# frozen_string_literal: true

class Session < ActiveRecord::Base
  include Authcat::Identity

  belongs_to :user
  acts_as_identity :user
end
