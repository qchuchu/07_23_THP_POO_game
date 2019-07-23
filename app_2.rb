require 'bundler'
Bundler.require

require_relative 'lib/game'
require_relative 'lib/player'


puts "-"*50
puts "|#{"Bienvenue sur 'ILS VEULENT TOUS MA POO' !".ljust(48)}|"
puts "|#{"Le but du jeu est d'être le dernier survivant !".ljust(48)}|"
puts "-"*50 + "\n\n"

puts "Quel est ton prénom, valeureux guerrier?"
print "> "
name = gets.chomp
human = HumanPlayer.new(name)
enemies = [Player.new('Josiane'), Player.new('José')]

while (human.life_points > 0) && (enemies.map{|en| en.life_points}.reduce(&:+) > 0)
  # Code de la bataille
  human.show_state
  puts "\nQuelle action veux-tu effectuer ?\n\n"
  puts "a - chercher une meilleure arme"
  puts "s - chercher à se soigner\n\n"
  puts "attaquer un joueur en vue :"
  enemies.length.times do |i|
    if enemies[i].life_points > 0
      print "#{i} - ".colorize(:green)
    else
      print "#{i} - ".colorize(:red)
    end
    enemies[i].show_state
  end
  print "\n> "
  user_input = gets.chomp
  print "\n"
  unless (['a','s'] + Array.new(enemies.length){ |i| i.to_s}).include? user_input
    puts "\nI don't know this input. Try again !"
    print "> "
    user_input = gets.chomp
  end
  # Action phase
  if user_input == 'a'
    human.search_weapon
  elsif user_input == 's'
    human.search_health_pack
  else
    human.attacks(enemies[user_input.to_i])
  end
  # Les autres enemies ripostent !
  puts "\nLes autres joueurs t'attaquent !" if (enemies.map{|en| en.life_points}.reduce(&:+) > 0)
  enemies.each do |player|
    player.attacks(human) if player.life_points > 0
  end
  gets.chomp
end

if human.life_points > 0
  puts "BRAVO ! TU AS GAGNE !"
else
  puts "Loser ! Tu as perdu !"
end
