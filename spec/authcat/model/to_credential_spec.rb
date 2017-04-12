require "spec_helper"

describe Authcat::Model::ToCredential do

  let!(:user_class) do
    Class.new(ActiveRecord::Base) do
      self.table_name = User.table_name

      include Authcat::Model::ToCredential
    end
  end

end
