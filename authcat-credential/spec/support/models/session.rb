# frozen_string_literal: true

class Session < ActiveRecord::Base
  include Authcat::Credential

  belongs_to :user
end
