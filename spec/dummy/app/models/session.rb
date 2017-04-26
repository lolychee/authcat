class Session
  include ActiveModel::Model

  attr_accessor :user
  attr_accessor :email, :password, :remember_me

  validates :email, presence: true
  validates :password, presence: true

  validate :email_should_found, if: -> { email.present? }
  validate :password_should_match, if: -> { user && password.present? }

  def email=(value)
    @email = value
  end

  def remember_me=(value)
    @remember_me = ActiveModel::Type::Boolean.new.cast(value)
  end

  def save(*)
    valid?
  end

  private

    def email_should_found
      errors.add(:email, "not found") unless self.user = User.find_by(email: email.downcase)
    end

    def password_should_match
      errors.add(:password, "not match") unless user.password_digest.verify(password)
    end
end
