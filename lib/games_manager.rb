require 'csv'
require_relative './games'

class GamesManager
  attr_reader :games

  def initialize(data)
    @games = create_games(data)
    # require 'pry'; binding.pry
  end

  def create_games(games_data)
    rows = CSV.read(games_data, headers: true)
    rows.map do |row|
      Game.new(row)
    end
  end

  def highest_total_score
    game_scores = @games.map { |game| game.total_goals }
    game_scores.max
  end

  def lowest_total_score
    game_scores = @games.map { |game| game.total_goals }
    game_scores.min
  end
end
