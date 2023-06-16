# frozen_string_literal: true

class UserEmail < ActiveRecord::Base
  include Authcat::Identifier::Record

  belongs_to :user
end
