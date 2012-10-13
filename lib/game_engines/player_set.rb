module GameEngines

  # A class for holding player sets
  #
  # A player set contains the following attributes
  #
  # * player_id
  # * strength (for swedish systems)
  # * bye (if the player has been bye once)
  # * opponent_ids (an array of player ids this opponent has already played with)
  # * last_win (true, false for knock out games)
  class PlayerSet

    attr_reader :id
    attr_accessor :strength,
      :bye,
      :opponent_ids,
      :last_win

    # Initializes the class and assigns basic attributes
    #
    # attrs may have the following options:
    # * strength (float)
    # * bye (boolean)
    # * opponent_ids (array of integers)
    # * last_win (boolean)
    #
    # @param [Integer] player's id
    # @params [Hash] a hash with player set attributes
    def initialize(player_id, attrs = {})
      @id = player_id
      @strength, @bye, @opponent_ids, @last_win =
        attrs.symbolize_keys.values_at(:strength, :bye, :opponent_ids, :last_win)
    end

    # Determines if this is the first round by checking if last_win is nil?
    # This only makes sence for knock out games
    #
    # @return [Boolean] result
    def first_round?
      @last_win.nil?
    end

    # Determines if this player won the last game by checking if last_win is
    #  true
    #
    # @return [Boolean] result
    def has_won?
      @last_win
    end

    # Determines if this player lost the last game by checking if last_win is
    #  false
    #
    # @return [Boolean] result
    def has_lost?
      @last_win == false
    end

  end
end
