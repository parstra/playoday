# -*- encoding : utf-8 -*-
require 'spec_helper'

describe TournamentUser do
  it { should belong_to :user }
  it { should belong_to :tournament }
end

