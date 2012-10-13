# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Tournament do
  it { should have_many :rounds }
end

