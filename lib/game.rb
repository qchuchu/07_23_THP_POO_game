require 'pry'

class Game
  attr_accessor :human_player, :enemies

  def initialize(name)
    @human_player = HumanPlayer.new(name)
    @enemies = []
    ['Jessie', 'James', 'Miaouss', 'Qulbutoké'].each do |rocket|
      @enemies << Player.new(rocket)
    end
  end

  def kill_player(player)
    @enemies.reject! {|enemy| enemy == player}
  end

  def is_still_ongoing?
    @human_player.life_points > 0 && !@enemies.empty?
  end

  def show_players
    @human_player.show_state
    puts "Il reste #{@enemies.count} ennemies\n\n"
  end

  def menu
    puts "Quelle action veux-tu effectuer ?\n\n"
    puts "a - chercher une meilleure arme"
    puts "s - chercher à se soigner\n\n"
    puts "attaquer un joueur en vue :"
    @enemies.length.times do |i|
      print "#{i} - ".colorize(:green)
      @enemies[i].show_state
    end
    print "\n"
  end

  def menu_choice(user_input)
    if user_input == 'a'
      @human_player.search_weapon
    elsif user_input == 's'
      @human_player.search_health_pack
    else
      @human_player.attacks(@enemies[user_input.to_i])
      if @enemies[user_input.to_i].life_points == 0
        kill_player(@enemies[user_input.to_i])
      end
    end
  end

  def ennemies_attack
    puts "\nLes autres joueurs t'attaquent !" if @enemies.count > 0
    @enemies.each do |enemy|
      enemy.attacks(@human_player)
    end
    print "\n"
  end

  def end
    if @enemies == []
      puts "BRAVO tu as gagné !"
    else
      puts "Loser ! Tu as perdu !"
    end
  end

  def ask_input
    print "> "
    user_input = gets.chomp
    unless (['a','s'] + Array.new(@enemies.length){ |i| i.to_s}).include? user_input
      puts "\nI don't know this input. Try again !"
      print "> "
      user_input = gets.chomp
    end
    puts "\n"
    user_input
  end
end
