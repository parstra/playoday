module GameEngines
  # Knock out game is log2(number_of_players) round game where players are
  #  knocked out when they lose a game.
  #
  # It requires a number of players that is a "power of two" or "power of two
  #  minus one" in order to be playable.
  #
  # e.g. 7 players are ok (1 will go bye) , 8 players are ok, but 12 are not
  class KnockOut

    # Knock out is initialized in any round with an array of:
    #  [player_id, last_game_win]
    #
    # Players that won the last game will play in this round
    #
    # @params [Array] an array of arrays (player sets)
    def initialize(player_set)
      @player_set = player_set

      @players = Hash[*@player_set.flatten]
      @player_ids = @players.keys

      @num_of_players = @player_set.length
    end

    # Determines if this player set is playable
    # It examines two cases:
    #
    #  * It's the first round (all last_game_win are false, or nil) then it
    #    requires a `N^2` or `N^2 - 1` number of players
    #  * It's a subsequent round that requires a `N`^2 number of players with
    #    last_game_win_status == true
    #
    # @return [Boolean] result
    def playable?
      if first_round?
        Math.log2(@num_of_players).modulo(1).zero? ||
          Math.log2(@num_of_players + 1).modulo(1).zero?
      else
        Math.log2(@num_of_players).modulo(1).zero?
      end
    end

    # Determines if this round is the first
    #
    # A first round is considered a round that all player_sets have all of their
    #  last_game_win is null or false
    #
    # @return [Boolean] result
    def first_round?
      @players.values.reject{|k| !k}.empty?
    end

    # Draws the next round.
    # It creates N / 2 new pairs with the players that have last_game_status ==
    #  win or just all players if this is the first round
    #
    # e.g. for a player_set [[1,false], [2, true], [5, true], [6, true]] the
    #  result will be [[2, 6]]
    #
    #  @return [Array] player_sets
    def draw
      ids = @player_ids

      if first_round?
        ids = @player_ids
      else
        ids = @player_set.select(&:last).map(&:first)
      end

      ids.in_groups_of(2)
    end
  end
end
