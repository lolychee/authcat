# frozen_string_literal: true

begin
  require "rails/railtie"
rescue LoadError
else

  module Authcat
    class Railtie < Rails::Railtie
      initializer "authcat" do |app|
         Authcat.secret_key ||= Rails.application.secrets.secret_key_base
       end
    end
  end

end
