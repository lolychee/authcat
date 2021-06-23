class Session < ActiveRecord::Base
  include Authcat::Account
end
