# frozen_string_literal: true

class UserResetPassword
  include ActiveModel::Model
  include ActiveModel::Attributes

  include Authcat::Model::Validators

  attribute :identifier
  attribute :password
  attribute :password_confirmation

  attribute :current_password
  attr_accessor :skip_current_password

  attr_accessor :user
  delegate :password_digest, to: :user, allow_nil: true

  with_options unless: :user do
    validates :identifier, presence: true
    validate :identifier_should_founded
  end

  validates :current_password, password_verify: :password_digest, unless: :skip_current_password

  with_options on: :save do
    validates :password, presence: true, confirmation: true
  end

  def save(*)
    valid?(:save) && user.update(password: password)
  end

  # def send(type)
  #   valid?(type)
  # end

  private

    def identifier_should_founded
      errors.add(:email, "not found") unless self.user = User.find_by_identifier(identifier)
    end
end
