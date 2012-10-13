# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Tournament do

  it { should have_many :rounds }
  it { should belong_to :company }
  it { should belong_to :owner }
  it { should have_many(:users).through(:tournament_users) }

  it { should validate_numericality_of :game_type }

  describe "methods" do

    let(:tournament) { FactoryGirl.create(:tournament) }

    it "create_match_hash! should populate match_hash with a md5 digest" do
      expect { tournament.create_tournament_hash! }.to change { tournament.tournament_hash }
    end
  end
end

