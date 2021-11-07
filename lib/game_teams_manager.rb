require 'csv'
require_relative './game_teams'
require_relative './statistics'

class GameTeamsManager
  include Statistics
  attr_reader :game_teams

  def initialize(game_teams)
    @game_teams = game_teams
  end

  def self.from_csv(game_teams_data)
    rows = CSV.read(game_teams_data, headers: true)
    game_teams = rows.map do |row|
      GameTeam.new(row)
    end
    GameTeamsManager.new(game_teams)
  end

  def best_offense
    team_average_goals(self.games_by_team).max_by {|team_id, avg_goals| avg_goals.max}.first
  end

  def worst_offense
    team_average_goals(self.games_by_team).min_by {|team_id, avg_goals| avg_goals.min}.first
  end

  def team_average_goals(team_games)
    team_games.transform_values do |game_teams|
      {average_goals: average_goals(game_teams).round(4)}
    end
  end

  def game_teams_by_team_id
    @game_teams.group_by {|game_team| game_team.team_id}
  end

  def games_by_team(team_games = @game_teams)
    team_games.group_by {|game_team| game_team.team_id}
  end

  def total_games(game_teams)
    game_teams.count
  end

  def total_goals(game_teams)
    game_teams.sum {|game_team| game_team.goals}
  end

  def average_goals(game_teams)
    total_goals(game_teams).to_f/total_games(game_teams)
  end

  def highest_scoring_visitor
    games = games_by_team(self.away_games)
    team_average_goals(games).max_by {|team_id, avg_goals| avg_goals.max}.first
  end

  def lowest_scoring_visitor
    games = games_by_team(self.away_games)
    team_average_goals(games).min_by {|team_id, avg_goals| avg_goals.min}.first
  end

  def highest_scoring_home_team
    games = games_by_team(self.home_games)
    team_average_goals(games).max_by {|team_id, avg_goals| avg_goals.max}.first
  end

  def lowest_scoring_home_team
    games = games_by_team(self.home_games)
    team_average_goals(games).min_by {|team_id, avg_goals| avg_goals.min}.first
  end

  def away_games
    @game_teams.select {|game_team| game_team.home? == false}
  end

  def home_games
    @game_teams.select {|game_team| game_team.home?}
  end

  def average_win_percentage(team_id)
    team_games = @game_teams.select {|game_team| game_team.team_id == team_id}
    (team_games.count {|team_game| team_game.win?} / team_games.count.to_f).round(2)
  end

  def goals_by_team_id
    game_teams_hash = game_teams_by_team_id
    goals_by_team_id = Hash.new(0)
    game_teams_hash.each do |team_id, game_teams|
      goals_by_team_id[team_id] = game_teams.map{|game_team| game_team.goals}
    end
    goals_by_team_id
  end
end
