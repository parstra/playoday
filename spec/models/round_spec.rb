# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Round do
  it { should belong_to :tournament }
  it { should have_many :matches }

  context "scopes" do
    let!(:active_rounds) { FactoryGirl.create_list(:active_round, 5) }
    let!(:inactive_rounds) { FactoryGirl.create_list(:round, 2) }
    it "active should fetch only active rounds" do
      Round.active.collect(&:id).should == active_rounds.collect(&:id)
      (Round.active.collect(&:id) & inactive_rounds.collect(&:id)).should be_empty
    end
  end
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

