require 'spec_helper'

describe Authcat::Model::Extensions::Login do

  class TestUser < ActiveRecord::Base
    self.table_name = User.table_name

    include Authcat::Model::Extensions::Login

  end



end