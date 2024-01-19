# frozen_string_literal: true

class Email < ActiveRecord::Base
  include Authcat::Identifier::Record

  belongs_to :user
end
