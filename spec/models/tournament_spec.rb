# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Tournament do

  it { should have_many :rounds }

  it { should validate_numericality_of :game_type }

end

