require 'csv'
require_relative './game_teams'
require_relative './statistics'

class GameTeamsManager
  include Statistics
  attr_reader :game_teams

  def initialize(data)
    @game_teams = create_game_teams(data)
  end

  def create_game_teams(game_teams_data)
    rows = CSV.read(game_teams_data, headers: true)
    rows.map do |row|
      GameTeam.new(row)
    end
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

  def away_games(team_id = nil)
    if team_id
      @game_teams.select {|game_team| game_team.home? == false && game_team.team_id == team_id}
    else
      @game_teams.select {|game_team| game_team.home? == false}
    end
  end


  def home_games
    @game_teams.select {|game_team| game_team.home?}
  end
end
