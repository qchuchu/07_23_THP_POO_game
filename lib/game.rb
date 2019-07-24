require 'bundler'
Bundler.require

class Game
  attr_accessor :human_player, :enemies_in_sight, :players_left

  def initialize(name, enemies_name = Array.new(10){|i| "Joueur#{i+1}"})
    @human_player = HumanPlayer.new(name)
    @enemies_name = enemies_name
    @enemies_in_sight = []
    @players_left = 10
  end

  #Check pour savoir si le jeu est toujours en cours ou non
  def is_still_ongoing?
    @human_player.life_points > 0 && @players_left > 0
  end

  #Montre l'état de la partie :
  def show_players
    # Etat du joueur principal
    @human_player.show_state
    # En fonction du nombre d'ennemis en vue, pour gérer l'inclusif
    if @enemies_in_sight.count == 0
      puts "Il y a 0 ennemi visible"
    elsif @enemies_in_sight.count == 1
      puts "Il y a 1 ennemi visible"
    else
      puts "#{@enemies_in_sight.count} ennemis sont visibles"
    end
    # En fonction du nombre de joueur au total, pour gérer l'inclusif
    if @players_left == 1
      puts "Il reste au total 1 ennemi dans le jeu"
    else
      puts "Il reste au total #{@players_left} ennemis dans le jeu"
    end
  end

  # Affiche le menu des choix que l'utilisateur peut effectuer
  def menu
    puts "Quelle action veux-tu effectuer ?\n\n"
    puts "a - chercher une meilleure arme"
    puts "s - chercher à se soigner\n\n"
    puts "attaquer un pokemon en vue :" if !@enemies_in_sight.empty?
    @enemies_in_sight.length.times do |i|
      print "#{i} - ".colorize(:green)
      @enemies_in_sight[i].show_state
    end
    print "\n"
  end

  # Prends en entrée un input de l'utilisateur, et réalise une action en conséquence
  def menu_choice(user_input)
    if user_input == 'a'
      @human_player.search_weapon
    elsif user_input == 's'
      @human_player.search_health_pack
    else
      puts "PIKACHU ATTAQUE ECLAIR!!!"
      @human_player.attacks(@enemies_in_sight[user_input.to_i])
      if @enemies_in_sight[user_input.to_i].life_points == 0
        kill_player(@enemies_in_sight[user_input.to_i])
      end
    end
  end

  # Demande un input d'action à l'utilisateur, et le renvoit
  # Tant que l'utilisateur n'a pas mis un input qui est dans la liste, lui demande de recommencer
  def action_input
    print "> "
    user_input = gets.chomp
    unless (['a','s'] + Array.new(@enemies_in_sight.length){ |i| i.to_s}).include? user_input
      puts "\nI don't know this input. Try again !"
      print "> "
      user_input = gets.chomp
    end
    puts "-"*50
    puts "\n"
    user_input
  end

  # Ajoute des nouveaux ennemis en vue
  def new_players_in_sight
    if @players_left == @enemies_in_sight.length
      puts "Tous les joueurs sont déjà en vue"
    else
      dice = rand(1..6)
      if dice == 1
        puts "Aucun joueur adverse arrive"
      elsif (2..4).include? dice || (@players_left - @enemies_in_sight.count == 1)
        add_enemy
      else
        add_enemy
        add_enemy
      end
    end
  end

  # Fait attaquer les ennemis en vue
  def ennemies_attack
    puts "\nLes autres joueurs t'attaquent !" if @enemies_in_sight.count > 0
    @enemies_in_sight.each do |enemy|
      enemy.attacks(@human_player) if @human_player.life_points > 0
    end
    print "\n"
  end

  # Fin du jeu
  def end
    if @players_left == 0
      puts "Tous les Pokemons ont été mis KO"
      puts "BRAVO tu as gagné !"
    else
      puts "#{@human_player.name} a perdu.. Tu perds 500 Pokedollars."
    end
  end

  private

  def kill_player(player)
    @enemies_in_sight.delete(player)
    @players_left -= 1
  end

  def add_enemy
    @enemies_in_sight << Player.new(@enemies_name.delete(@enemies_name.sample))
    puts "Un nouvel ennemi arrive ! Oh, il s'agit de #{@enemies_in_sight[-1].name}!"
  end

end
