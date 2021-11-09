require 'csv'
require_relative './game_teams'
require_relative './statistics'

class GameTeamsManager
  include Statistics
  attr_reader :game_teams

  def initialize(game_teams)
    @game_teams = []
    if game_teams.class != Array
      @game_teams << game_teams
    else
      @game_teams = game_teams
    end
  end

  def self.from_csv(game_teams_data)
    rows = CSV.read(game_teams_data, headers: true)
    game_teams = rows.map do |row|
      GameTeam.new(row)
    end
    GameTeamsManager.new(game_teams)
  end

  def offense
    team_average_goals(self.games_by_team)
  end

  def team_average_goals(team_games)
    x = team_games.transform_values do |game_teams|
      average_goals(game_teams).round(4)
    end
    # require 'pry'; binding.pry
  end

  def game_teams_by_team_id(game_teams = @game_teams)
    game_teams.group_by {|game_team| game_team.team_id}
  end

  def game_teams_mngr_by_team_id
    game_teams = @game_teams.group_by {|game_team| game_team.team_id}
    gt_mngr_by_teams = Hash.new()
    game_teams.each do |team_id, game_teams|
      gt_mngr_by_teams[team_id] = GameTeamsManager.new(game_teams)
    end
    gt_mngr_by_teams
  end

  def games_by_team(team_games = @game_teams)
    team_games.group_by {|game_team| game_team.team_id}
  end

  def remove_team(team_id)
    @game_teams.reject!{|game_team| game_team.team_id == team_id}
    return self
  end

  def game_teams_with_game_ids(game_ids)
    @game_teams.select{|game_team| game_ids.include?(game_team.game_id)}
  end

  def gt_w_game_ids_mngr(game_ids)
    game_teams = @game_teams.select{|game_team| game_ids.include?(game_team.game_id)}
    gt_mngr = GameTeamsManager.new(game_teams)
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

  def scoring_visitor
    team_average_goals(games_by_team(self.away_games))
  end

  def scoring_home_team
    team_average_goals(games_by_team(self.home_games))
  end

  def away_games
    @game_teams.select {|game_team| game_team.home? == false}
  end

  def home_games
    @game_teams.select {|game_team| game_team.home?}
  end

  def average_win_percentage(team_id, game_teams = @game_teams)
    team_games = game_teams.select {|game_team| game_team.team_id == team_id}
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

  def team_accuracy(game_ids)
    games = @game_teams.select {|game_team| game_ids.include?(game_team.game_id)}
    games_by_team = games.group_by {|game| game.team_id}
    team_accuracy = games_by_team.transform_values do |game_teams|
      goals = game_teams.reduce(0) {|goals, game_team| goals + game_team.goals}
      shots = game_teams.reduce(0) {|shots, game_team| shots + game_team.shots}
      (goals/shots.to_f).round(4)
    end
  end

  def tackles(game_ids)
    games = @game_teams.select {|game_team| game_ids.include?(game_team.game_id)}
    games_by_team = games.group_by {|game| game.team_id}
    games_by_team.transform_values do |game_teams|
      game_teams.reduce(0) {|tackles, game_team| tackles + game_team.tackles}
    end
  end

  def percentage_wins_by_coach(game_ids)
    games = @game_teams.select {|game_team| game_ids.include?(game_team.game_id)}
    games_by_coach = games.group_by {|game| game.head_coach}
    win_percentage = games_by_coach.transform_values do |game_teams|
      (game_teams.count {|game| game.win?} / game_teams.count.to_f).round(2)
    end
  end

  def gts_of_opposing_team(team_id)
    gts = @game_teams.select{|gt| gt.team_id == team_id}
    game_ids = gts.map{|gt|gt.game_id}
    gts_with_team_and_opponents = game_teams_with_game_ids(game_ids)
    opponent_gts = gts_with_team_and_opponents.select{|gt|gt.team_id != team_id}
  end

  def opponent_w_perc(team_id)
    gts_by_team_id = game_teams_by_team_id(gts_of_opposing_team(team_id))
    owp = gts_by_team_id.each_with_object({}) do |(team_id, gts), owp|
      owp[team_id] = average_win_percentage(team_id, gts)
    end
  end
end
