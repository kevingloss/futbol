# Module Place Holder
# Potential Module Methods

# pass in an array of game_team objects and it returns the total goals
# def total_goals(all_games)
#   all_games.sum { |game| game.goals }
# end

module Statistics
  # def win_percentage(wins, losses, ties)
  #   win_percentage = (wins + 0.5 * ties)/ (wins + losses + 0.5 * ties)
  # end
  def win_percentage(wins, losses)
    win_percentage = (wins)/ (wins + losses)
  end
end
