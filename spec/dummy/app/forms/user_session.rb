# frozen_string_literal: true

class UserSession
  include ActiveModel::Model
  include ActiveModel::Attributes

  include Authcat::Model::Validators

  attribute :identifier,  :string
  attribute :password,    :string
  attribute :remember_me, :boolean

  attr_accessor :user
  delegate :password_digest, to: :user, allow_nil: true

  with_options unless: :user do
    validates :identifier, presence: true
    validate :identifier_should_founded
  end

  validates :password, presence: true, password_verify: true

  def save(*)
    valid?
  end

  private

    def identifier_should_founded
      errors.add(:identifier, "not found") unless self.user = User.find_by_identifier(identifier)
    end
end
