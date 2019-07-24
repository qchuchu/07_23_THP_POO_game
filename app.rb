require 'bundler'
Bundler.require

$:.unshift File.expand_path("../lib", __FILE__)

require 'game'
require 'player'

player1 = Player.new('Josiane')
player2 = Player.new('José')

puts "Voici l'état de chaque joueur"
player1.show_state
player2.show_state

tour = 0
while (player1.life_points > 0) && (player2.life_points > 0)
  puts "\nPassons à la phase d'attaque :"
  player1.attacks(player2)
  player2.attacks(player1) if player2.life_points > 0
  puts "\nVoici l'état de nos joueurs"
  player1.show_state
  player2.show_state
  tour += 1
end

winner = [player1, player2].max{ |a, b| a.life_points <=> b.life_points }

puts "\nLe vainqueur de ce combat est #{winner.name} ! Il/Elle a gagné au bout de #{tour} tours"
