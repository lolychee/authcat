# frozen_string_literal: true

module Authcat
  module MultiFactor
    module BackupCodes
      def self.included(base)
        base.include Password::SecurePassword
        base.extend ClassMethods
      end

      module ClassMethods
        def has_backup_codes(attribute = :backup_codes, generator: ->(s) { s.times.map { SecureRandom.hex(8) } }, **opts)
          self.has_secure_password attribute, array: true, **opts

          mod = Module.new

          mod.define_method("generate_#{attribute}") do |size = 8|
            self.send("#{attribute}=", generator.call(size))
          end

          mod.define_method("#{attribute}_verify") do |code, revoke: false|
            column_name = "#{attribute}#{self.class.password_suffix}"
            codes = self.send(column_name)
            passcode = codes.try(:find) { |c| c == code }
            update_column(column_name => codes - [passcode]) if revoke && passcode
            !!passcode
          end

          self.include mod
        end
      end
    end
  end
end
