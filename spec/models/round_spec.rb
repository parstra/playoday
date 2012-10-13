# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Round do
  it { should belong_to :tournament }
  it { should have_many :matches }
end

