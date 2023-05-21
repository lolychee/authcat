# frozen_string_literal: true

class UserIdentifier < ActiveRecord::Base
  include Authcat::Identifier::Record

  belongs_to :user
end
