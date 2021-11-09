require 'csv'
require_relative './games'
require_relative './statistics'

class GamesManager
  include Statistics
  attr_reader :games

  def initialize(games)
    @games = []
    if games.class != Array
      @games << games
    else
      @games = games
    end
  end

  def self.from_csv(games_data)
    rows = CSV.read(games_data, headers: true)
    games = rows.map do |row|
      Game.new(row)
    end
    GamesManager.new(games)
  end

  def games_by_season(games = @games)
    games_by_season = @games.group_by { |game| game.season }
  end

  def count_of_games_by_season
    games_by_season.each_with_object({}) do |(season, games), new_hash|
      new_hash[season] = games.length
    end
  end

  def total_goals(games = @games)
    total_goals = games.map { |game| game.total_goals }
  end

  def average_goals_per_game(games = @games)
    (total_goals(games).sum.to_f / total_goals(games).length.to_f).round(2)
  end

  def highest_total_score
    @games.map {|game| game.total_goals}.max
  end

  def lowest_total_score
    @games.map {|game| game.total_goals}.min
  end

  def total_games
    @games.count
  end

  def total_visitor_wins
    @games.select{ |game| game.away_goals > game.home_goals}.count
  end

  def total_home_wins
    @games.select{|game| game.away_goals < game.home_goals}.count
  end

  def total_ties
    @games.select{|game| game.away_goals == game.home_goals}.count
  end

  def games_in_season(season, games = @games)
    games_in_season = @games.find_all { |game| game.season == season }
  end

  def games_with_any_team_id(team_id)
    @games.find_all{|game| game.home_team_id == team_id || game.away_team_id == team_id}
  end

  def game_ids_in_games(games)
    game_ids_in_games = games.map { |game| game.game_id }
  end

  def game_ids_in_game_mngr
    game_ids_in_games = @games.map { |game| game.game_id }
  end

  def seasons
    @games.map {|game| game.season}.uniq
  end

  def game_ids_in_s(season)
    game_ids_in_games(games_in_season(season))
  end
end
