# Provides helper methods for the cup tournament
#
# Actually methods in this module try to bridge between the
#  Tournament, Round, Match models in the database and the
#  GameEngines::PlayerSet structures.
#
# Finaly , a new round and matches for that round are generated
module CupTournament

  # Moves to next round by:
  #
  # * creating a new round
  # * generates a player set and passes it on to the cup game engine
  # * finally creates the match pairs the engine has generated
  def move_to_next_round
    # we need the current round to determine wins for the next round
    current_round = self.rounds.last

    if current_round.nil?
      # there were no previous matches, this is the first round
      # the gaming engine knows what to do
      player_set = self.users.collect{|player|
        GameEngines::PlayerSet.new(player.id)
      }

      # get match pairs from the engine
      match_pairs = GameEngines::KnockOut.new(player_set).draw

    else
      # get winners from the last matches
      winner_ids = current_round.matches.map(&:winner_id)

      # create a player set
      player_set = winner_ids.map do |winner_id|
        GameEngines::PlayerSet.new(winner_id, {last_win: true})
      end

      match_pairs = GameEngines::KnockOut.new(player_set).draw

      current_round.active = false
      current_round.save
    end

    # create a new round
    round = Round.new
    round.active = true

    self.rounds << round

    # match_pairs is an array of player_id pairs
    # e.g. [[1,2], [3,4]]
    match_pairs.each do |pair|
      #get player ids
      home_player_id, away_player_id = pair

      match = Match.new
      match.home_player_id = home_player_id
      match.away_player_id = away_player_id

      round.matches << match
    end

  end
end
