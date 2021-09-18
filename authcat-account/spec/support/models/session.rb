# frozen_string_literal: true

class Session < ActiveRecord::Base
  include Authcat::Account
end
