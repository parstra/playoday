# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Round do
  it { should belong_to :tournament }
  it { should have_many :matches }
end

# == Schema Information
#
# Table name: rounds
#
#  id            :integer          not null, primary key
#  tournament_id :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  started_at    :datetime
#  ended_at      :datetime
#

