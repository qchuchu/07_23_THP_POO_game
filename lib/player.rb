class Player
  attr_accessor :name, :life_points

  def initialize(name)
    @name = name
    @life_points = 10
  end

  def show_state
    str = "#{@name} a #{@life_points} points de vie"
    if @life_points > 0
      puts str.colorize(:green)
    else
      puts str.colorize(:red)
    end
  end

  def gets_damage(int)
    @life_points = [@life_points - int, 0].max
    puts "#{@name} a été tué !" if @life_points == 0
  end

  def attacks(player_attacked)
    puts "#{@name} attaque #{player_attacked.name}"
    dmg = compute_damage
    puts "Le joueur inflige #{dmg} points de dommages"
    player_attacked.gets_damage(dmg)
  end

  def compute_damage
    rand(1..6)
  end
end

class HumanPlayer < Player
  attr_accessor :weapon_level

  def initialize(name)
    super(name)
    @life_points = 100
    @weapon_level = 1
  end

  def show_state
    str = "#{@name} a #{@life_points} points de vie et un pokemon de niveau #{@weapon_level}"
    if @life_points > 0
      puts str.colorize(:green)
    else
      puts str.colorize(:red)
    end
  end

  def compute_damage
    rand(1..6) * @weapon_level
  end

  def search_weapon
    level = rand(1..6)
    puts "Tu as trouvé un pokemon de niveau #{level}"
    if level > @weapon_level
      puts "Youhou ! il est meilleur que ton pokemon actuel : PIKACHU JE TE CHOISIS!"
      @weapon_level = level
    else
      puts "M@*#$... C'est un Rattata tout pourri..."
    end
  end

  def search_health_pack
    puts "On part à la recherche d'une Potion !"
    level = rand(1..6)
    if level == 1
      puts "Tu n'as rien trouvé..."
    elsif (2..5).include? level
      puts "Bravo, tu as trouvé une Super Potion ! +50 points de vie !"
      @life_points = [100, @life_points + 50].min
    else
      puts "Waow, tu as trouvé une Hyper Potion ! +80 points de vie !"
      @life_points = [100, @life_points + 80].min
    end
  end
end
