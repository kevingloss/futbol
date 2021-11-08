require 'csv'
require_relative './games'
require_relative './statistics'

class GamesManager
  include Statistics
  attr_reader :games

  def initialize(games)
    @games = games
  end

  def self.from_csv(games_data)
    rows = CSV.read(games_data, headers: true)
    games = rows.map do |row|
      Game.new(row)
    end
    GamesManager.new(games)
  end



  def games_by_season
    games_by_season = @games.group_by { |game| game.season }
  end

  def count_of_games_by_season
    games_by_season = self.games_by_season
    count_of_games_by_season = Hash.new(0)
    games_by_season.each do |season, games|
      count_of_games_by_season[season] = games.length
    end
    count_of_games_by_season
  end

  # Average number of goals scored in a game across all seasons including
  # both home and away goals (rounded to the nearest 100th) - float
  def average_goals_per_game
    total_goals = @games.map { |game| game.total_goals }
    avg_goals_per_game = (total_goals.sum.to_f / total_goals.length.to_f).round(2)
  end

  def highest_total_score
    @games.map { |game| game.total_goals }.max
  end

  def lowest_total_score
    @games.map { |game| game.total_goals }.min
  end

  def total_games
        @games.count
  end

  def total_visitor_wins
    visitor_wins = []
    @games.each do |game|
      visitor_wins.push(game) if game.away_goals > game.home_goals
    end
    visitor_wins.count
  end

  def total_home_wins
    home_wins = []
    @games.each do |game|
      home_wins.push(game) if game.away_goals < game.home_goals
    end
    home_wins.count
  end

  def total_ties
    ties = []
    @games.each do |game|
      ties.push(game) if game.away_goals == game.home_goals
    end
    ties.count
  end
end
