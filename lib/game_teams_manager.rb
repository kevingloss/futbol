require 'csv'
require_relative './game_teams'

class GameTeamsManager
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
    team_average_goals.max_by {|team_id, avg_goals| avg_goals.max}.first
  end

  def team_average_goals
    all_games_by_team.transform_values do |game_teams|
      {average_goals: average_goals(game_teams).round(4)}
    end
  end

  #best_offense
  def all_games_by_team
    @game_teams.group_by {|game_team| game_team.team_id}
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
end
