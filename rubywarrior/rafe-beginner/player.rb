class Player
  MAX_HEALTH = 20
  DIRECTIONS = [:forward, :backward]
  # DIRECTIONS = [:backward, :forward]

  def play_turn(warrior)
    @direction = DIRECTIONS.fetch(0) unless @direction
    @warrior = warrior
    @action_taken = false

    check_for_rest unless @action_taken
    check_for_walk unless @action_taken
    check_for_captive unless @action_taken
    check_direction unless @action_taken
    check_attack unless @action_taken

    @current_health = @warrior.health
  end

  def check_for_rest
    if @warrior.feel(@direction).empty?
      if @warrior.health < MAX_HEALTH && !taking_damage?
        @warrior.rest!
        @action_taken = true
      else
        if wounded?(15)
          @warrior.walk!(:backward)
          @action_taken = true
        end
      end
    end
  end

  def check_for_walk
    if @warrior.feel(@direction).empty?
      @warrior.walk!(@direction)
      @action_taken = true
    end
  end

  def check_for_captive
    if @warrior.feel(@direction).captive?
      @warrior.rescue!(@direction)
      @action_taken = true
    end
  end

  def check_direction
    if @warrior.feel(@direction).wall?
      @warrior.pivot!
      @action_taken = true
      # @direction = DIRECTIONS.fetch(DIRECTIONS.index(@direction) + 1)
    end
  end

  def check_attack
    @warrior.attack!(@direction)
    @action_taken = true
  end

  def taking_damage?
    if @warrior.health < (@current_health || MAX_HEALTH)
      true
    else
      false
    end
  end

  def wounded?(acceptable_health)
    @warrior.health <= acceptable_health
  end
end
