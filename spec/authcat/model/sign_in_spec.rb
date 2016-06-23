require 'spec_helper'

describe Authcat::Model::SignIn do

  let!(:user_class) do
    Class.new(ActiveRecord::Base) do
      self.table_name = User.table_name

      include Authcat::Model::SignIn
    end
  end


end
