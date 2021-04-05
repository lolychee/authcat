module Encryptor
  extend ActiveSupport::Concern

  included do
    helper_method :encryptor
  end

  def encryptor
    @encryptor ||= begin
      key = session[:encrypt_key] ||= begin
        len   = ActiveSupport::MessageEncryptor.key_len
        salt  = SecureRandom.hex len
        key = ActiveSupport::KeyGenerator.new(Rails.application.secrets.secret_key_base).generate_key(salt, len)
        Base64.encode64(key)
      end

      ActiveSupport::MessageEncryptor.new(Base64.decode64(key), serializer: JSON)
    end
  end
end
