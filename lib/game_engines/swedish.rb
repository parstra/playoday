module GameEngines
  # Implements the swedish gaming algorithm
  #
  # This algorithm requires players have a "strength" attribute that reflects
  #  their competence. On every round, pairs are selected so that players with
  #  similar strength play together.
  #
  # e.g. image 4 players with the following scores. 1, 5, 2, 4
  # Player with score 5 will play with player with score 4 and player with score
  # 1 will play with player with score 2 ([[5,4], [1,2]])
  #
  # Of course if a pair has been previously selected it will skip to the next
  # closest score for which a pair hasn't already been selected
  #
  # If the number of players is odd then there will be a bye player on each
  # round
  #
  # Round number is not necessary for drawing
  class Swedish
    # Initializes the class with player sets
    # Player sets is an array of {GameEngines::PlayerSet}
    def initialize(player_sets)
      @player_sets = player_sets
      # get players sort by their strength (from biggest to smaller)
      @players_by_score = player_sets.sort_by(&:strength).reverse

      @needs_byeing = player_sets.length.modulo(2) > 0

      # get all player ids that have already byeed
      @byeed_ids = @player_sets.select(&:bye).map(&:id)
    end

    # Determines if this draw will be byeable (meaning it will have a player
    #  in 'bye' mode)
    #
    # @return [Boolean] result
    def byeable?
      @needs_byeing
    end

    # Calculates the player's id that will be byeed
    #
    # It has a preference in bye-ing low strength players
    #
    # @return [Boolean] result
    def to_be_byeed_id
      return nil if !byeable?
      return @players_by_score.last.id if @byeed_ids.empty?

      # we'll substract already byeed ids from the list of available pool ids
      (@players_by_score.map(&:id) - @byeed_ids).last
    end

    # Draws the next round
    #
    # If first determines the player that will be byeed (if any)
    #
    # Then it creates pair depending on the current strength making sure
    # selected pairs have not played before
    #
    # @return [Array] an array of match pairs
    def draw
      pairs = []

      # get a new instance of players, we'll have to remove the pair
      # each time a pair is found
      players = @players_by_score.clone

      # if we have a byeed player substract him now
      if byeable?
        players.reject!{|p| p.id == to_be_byeed_id}
      end

      while players.any? do
        player = players.first
        # get the available player_ids (remove the current selected player also)
        player_ids = players.map(&:id) - [player.id]

        # opponent will be determined by substracting opponent_ids from
        # available players (which are already sorted)
        opponent_id = (player_ids - player.opponent_ids).first

        pairs << [player.id, opponent_id]

        # no remove the players of this pair
        players.delete(player)
        players.reject!{|p| p.id == opponent_id}
      end

      if byeable?
        pairs << [to_be_byeed_id, nil]
      end

      pairs
    end
  end
end
