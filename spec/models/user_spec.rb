# -*- encoding : utf-8 -*-
require 'spec_helper'
describe User do

  it { should have_many(:companies).through(:companies_users) }
  it { should have_many(:tournaments).through(:tournament_users) }

end

