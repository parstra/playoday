# Provides helper methods for the cup tournament
#
# Actually methods in this module try to bridge between the
#  Tournament, Round, Match models in the database and the
#  GameEngines::PlayerSet structures.
#
# In swedish games only the strength of the user is important
#  and it's previous opponents. We'll gather statistics for every
#  player from their previous matches.
module SwedishTournament

  # Moves to the next round by:
  #
  # * creating a new round
  # * gathers player_sets for all players by looking up their matches
  # * passes on the playerset to the swedish game engine
  # * creates matches with the results generated
  def move_to_next_round
    round_ids = self.round_ids

    player_set = self.users.map do |player|
      # get all matches of this player
      matches = Match.where(round_id: round_ids).for_user(player)
      # strength is actually numbef or wins
      strength = matches.select{|m| m.winner_id == player.id}.length
      # player has byeed if involved in a match with no opponent
      byeed = matches.select{|m| m.home_player_id.nil? || m.away_player_id.nil?}.any?

      # get opponent id from every match
      opponent_ids = matches.select{|m|
        opponent_id = m.away_player_id
        # if the current player was the away player then choose the home_player_id
        if opponent_id == player.id
          opponent_id = m.home_player_id
        end

        opponent_id
      }

      GameEngines::PlayerSet.new(player.id, {bye: byeed, 
                                  opponent_ids: opponent_ids,
                                  strength: strength})

    end

    # we have the player set, now create the round
    current_round = self.rounds.last

    if current_round
      current_round.active = false
      current_round.save!
    end

    round = Round.new
    round.active = true

    self.rounds << round

    match_pairs = GameEngines::Swedish.new(player_set).draw

    match_pairs.each do |pair|
      home_player_id, away_player_id = pair

      match = Match.new
      match.home_player_id = home_player_id
      match.away_player_id = away_player_id

      # if bye then close the match
      if away_player_id.nil?
        match.played = true
        match.winner_id = home_player_id
      end

      round.matches << match
    end
  end
end
