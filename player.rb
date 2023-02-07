class Player
  attr_reader :health, :warrior


  def play_turn(warrior)
    @warrior = warrior
    
    return action(:pivot!) if warrior.feel.wall?
    return action(:walk!) if warrior.look.map(&:to_s).empty?
    return action(:rescue!, :backward) if warrior.feel(:backward).captive?
    return action(:walk!, :backward) if warrior.look(:backward).map(&:to_s).any?("Captive")
    return action(:rescue!) if warrior.feel.captive?
    return action(:walk!) if warrior.feel.empty? && warrior.look.map(&:to_s).any?("Captive")
    return action(:attack!) if warrior.feel.enemy?
    return action(:shoot!) if range_enemy? || is_a_wizard?
    return action(:walk!, :backward) if taking_damage? && warrior.health < 10
    return action(:rest!) if warrior.health < 20 && warrior.feel.empty? && !taking_damage?


    action(:walk!)
  end

  def taking_damage?
    health && warrior.health < health
  end

  def range_enemy?
    warrior.look.map(&:to_s).any?("Archer")
  end

  def is_a_wizard?
    warrior.look.map(&:to_s).any?("Wizard")
  end

  def action(name, *arg)
    warrior.send(name, *arg)
    @health = warrior.health
  end
end
