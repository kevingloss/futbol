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



  def games_by_season
    games_by_season = @games.group_by { |game| game.season }
  end

  def count_of_games_by_season
    games_by_season = self.games_by_season
    count_of_games_by_season = games_by_season.transform_values do |season, games|
      games.length
    end
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


  def method_name1

  end

  def method_name2

  end

  def method_name3

  end

  def method_name4

  end






























end
