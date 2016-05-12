class UserSession
  include ActiveModel::Model
  # include Authcat::Model::Session

  # subject :user
  attr_accessor :user
  attr_accessor :email, :password

  def self.user_class
    @user_class ||= name.sub(/Session\Z/, '').constantize
  end

  def self.user_class=(klass)
    @user_class = klass
  end

  def lookup_user(*attributes)
    klass = self.class.user_class

    attributes.each do |attribute|
      value = self.send(attribute)

      if user = klass.try("find_by_#{attribute}", value) || klass.find_by(attribute => value)
        return self.user = user
      end
    end
    nil
  end

  def create(*)
    validate
  end

  class FoundValidator < ActiveModel::EachValidator

    def validate_each(record, attribute, value)
      record.errors.add(attribute, 'not found.') unless record.lookup_user(attribute)
    end

  end

  class AuthenticateValidator < ActiveModel::EachValidator

    def validate_each(record, attribute, value)
      record.errors.add(attribute, 'not match.') unless record.user.try(:authenticate, attribute => value)
    end

  end


  validates :email, found: true
  validates :password, authenticate: true

end
