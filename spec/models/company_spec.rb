# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Company do
  it { should have_many(:users) }

  it { should validate_presence_of :name }
  it { should validate_uniqueness_of :name }

end