# frozen_string_literal: true

class UserIdentifier < ActiveRecord::Base
  include Authcat::Identity::Record

  belongs_to :user
end
