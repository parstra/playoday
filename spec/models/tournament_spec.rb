# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Tournament do

  it { should have_many :rounds }
  it { should belong_to :company }
  it { should belong_to :owner }
  it { should have_many(:users).through(:tournament_users) }

  it { should validate_numericality_of :game_type }
  it { should validate_presence_of :duration }
  it { should validate_presence_of :name }
  it { should validate_presence_of :total_rounds }
  it { should validate_presence_of :round_duration }
  it { should validate_presence_of :owner_id }
  it { should validate_presence_of :company_id }


  context "scopes" do
    let!(:active_tournaments) { FactoryGirl.create_list(:tournament, 4, active: true) }
    let!(:inactive_tournaments) { FactoryGirl.create_list(:tournament, 4, active: false) }

    it "active fetches active tournaments" do
      Tournament.active.collect(&:id).should =~ active_tournaments.collect(&:id)
      (Tournament.active.collect(&:id) & inactive_tournaments.collect(&:id)).should be_empty
    end
  end

  context "methods" do
    let(:active_tournament) { FactoryGirl.create(:tournament, active: true) }
    let(:inactive_tournament) { FactoryGirl.create(:tournament, active: false) }

    it ".active" do
      active_tournament.should be_active
      inactive_tournament.should_not be_active
    end
  end

  context "before create" do
    let(:new_tournament) { FactoryGirl.build(:tournament) }

    it "should set a tournament hash" do
      expect { new_tournament.save }.
        to change { new_tournament.tournament_hash }.from(nil)
      new_tournament.tournament_hash.length.should == 32
    end

  end
end

# == Schema Information
#
# Table name: tournaments
#
#  id              :integer          not null, primary key
#  description     :string(255)      not null
#  tournament_hash :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  game_type       :integer
#  company_id      :integer
#  owner_id        :integer
#  name            :string(255)
#  duration        :integer
#  total_rounds    :integer
#  round_duration  :integer
#  active          :boolean          default(FALSE)
#  started_at      :datetime
#

