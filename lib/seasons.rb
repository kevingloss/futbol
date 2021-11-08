require 'csv'
require_relative './games'
require_relative './game_teams'

class Season
  # include Statistics
  attr_reader :game_teams, :games

  def initialize(games, game_teams)
    @game_teams = game_teams
    @games = games
  end

  def self.from_csv(locations)
    rows = CSV.read(locations[:games], headers: true)
    games = rows.map do |row|
      Game.new(row)
    end
    rows = CSV.read(locations[:game_teams], headers: true)
    game_teams = rows.map do |row|
      GameTeam.new(row)
    end
    Season.new(games, game_teams)
  end

  def game_teams_by_games(games)
    game_ids = game_ids_in_games(games)
    @game_teams.find_all{|game_team|game_ids.include?(game_team.game_id)}
  end
  # helper method to collect all game_teams in a given season
  def game_teams_in_season(season)
    games_in_season = games_in_season(season)
    game_teams_in_season = game_teams_by_games(games_in_season)
  end

  def games_in_season(season)
    games_in_season = @games.find_all { |game| game.season == season }
  end

  def game_ids_in_games(games)
    game_ids_in_games = games.map { |game| game.game_id }
  end
end
