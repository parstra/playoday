# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Company do
  it { should have_many(:users) }

  it { should validate_presence_of :name }
  it { should validate_uniqueness_of :name }

end

# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name       :string(255)
#

