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
    puts "Le joueur #{@name} a été tué !" if @life_points == 0
  end

  def attacks(player_attacked)
    puts "Le joueur #{@name} attaque le joueur #{player_attacked.name}"
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
    str = "#{@name} a #{@life_points} points de vie et une arme de niveau #{@weapon_level}"
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
    puts "Tu as trouvé une arme de niveau #{level}"
    if level > @weapon_level
      puts "Youhou ! elle est meilleure que ton arme actuelle : tu la prends"
      @weapon_level = level
    else
      puts "M@*#$... elle n'est pas mieux que ton arme actuelle..."
    end
  end

  def search_health_pack
    puts "On part à la recherche d'un Health Pack !"
    level = rand(1..6)
    if level == 1
      puts "Tu n'as rien trouvé..."
    elsif (2..5).include? level
      puts "Bravo, tu as trouvé un pack de +50 points de vie !"
      @life_points = [100, @life_points + 50].min
    else
      puts "Waow, tu as trouvé un pack de +80 points de vie !"
      @life_points = [100, @life_points + 80].min
    end
  end
end
