require_relative './teams_manager'
require_relative './game_teams_manager'
require_relative './games_manager'
require_relative './statistics'

class StatTracker
  include Statistics
  attr_accessor :games_mngr, :teams_mngr, :gt_mngr

  def initialize(locations)
    @games_mngr = GamesManager.from_csv(locations[:games])
    @teams_mngr = TeamsManager.from_csv(locations[:teams])
    @gt_mngr = GameTeamsManager.from_csv(locations[:game_teams])
  end

  def self.from_csv(locations)
    stat_tracker = StatTracker.new(locations)
  end
  # Game Statistics Methods
  def highest_total_score
    @games_mngr.highest_total_score
  end

  def lowest_total_score
    @games_mngr.lowest_total_score
  end

  def percentage_visitor_wins
    (@games_mngr.total_visitor_wins / @games_mngr.total_games.to_f).round(2)
  end

  def percentage_home_wins
    (@games_mngr.total_home_wins / @games_mngr.total_games.to_f).round(2)
  end

  def percentage_ties
    (@games_mngr.total_ties / @games_mngr.total_games.to_f).round(2)
  end

  def count_of_games_by_season
    count_of_games_by_season = @games_mngr.count_of_games_by_season
  end

  def average_goals_per_game
    avg_goals_per_game = @games_mngr.average_goals_per_game
  end

  def average_goals_by_season
    avg_goals_by_season = Hash.new(0)
    games_by_season = @games_mngr.games.group_by{|game|game.season}
    games_by_season.each do |season, games|
      total_goals = games.map{|game| game.away_goals + game.home_goals}.sum
      avg_goals = (total_goals/games.count.to_f)
      avg_goals_by_season[season] = avg_goals.round(2)
    end
    return avg_goals_by_season
  end
  # League Statistics
  def count_of_teams
    @teams_mngr.count_of_teams
  end

  def best_offense
    @teams_mngr.find_team_name(@gt_mngr.best_offense)
  end

  def worst_offense
    @teams_mngr.find_team_name(@gt_mngr.worst_offense)
  end

  def highest_scoring_visitor
    @teams_mngr.find_team_name(@gt_mngr.highest_scoring_visitor)
  end

  def lowest_scoring_visitor
    @teams_mngr.find_team_name(@gt_mngr.lowest_scoring_visitor)
  end

  def highest_scoring_home_team
    @teams_mngr.find_team_name(@gt_mngr.highest_scoring_home_team)
  end

  def lowest_scoring_home_team
    @teams_mngr.find_team_name(@gt_mngr.lowest_scoring_home_team)
  end
  #Team Statistics
  def team_info(team_id)
    @teams_mngr.team_info(team_id)
  end

  def find_team(team_id)
    @teams_mngr.teams.find {|team| team.team_id == team_id}
  end

  # def best_season(team_id)
  #   @games_mngr.seasons.max_by do |season|
  #     team_season_win_percentage(team_id, season) #pass in two arguments and include the season?
  #   end
  # end

  def best_season(team_id)
    win_percentage_by_season(team_id).max_by{|season, win_perc| win_perc}[0]
  end


  def worst_season(team_id)
    win_percentage_by_season(team_id).min_by{|season, win_perc| win_perc}[0]
  end

  def win_percentage_by_season(team_id)
    games_with_team_by_season = @games_mngr.games_by_season(@games_mngr.games_with_any_team_id(team_id))
    win_percentage_by_season = Hash.new
    games_with_team_by_season.each do |season, games|
      game_teams = game_teams_by_games(games)
      win_percentage = @gt_mngr.average_win_percentage(team_id, game_teams)
      win_percentage_by_season[season] = win_percentage
    end
    win_percentage_by_season
  end

  # def team_season_win_percentage(team_id, season)
  #   # return 0 if team_games_by_season(team_id, season).count == 0
  #
  #   #this line is returning an infinity when there are zero games in a season
  #   season_wins(team_id, season).count/team_games_by_season(team_id, season).count.to_f
  # end

  #this is going through the games and not game_teams where the wins are saved
  # def team_games_by_season(team_id, season)
  #   seasons_games = games_in_season(season)
  #   team_games_in_season = seasons_games.find_all do |game|
  #     game.away_team_id == team_id || game.home_team_id == team_id
  #   end
  # end

  #this method was just searching all the game_teams originally, need to limit it
  #changed to Leland's helper method to sort by games in season



  # def season_wins(team_id, season)
  #   game_teams_in_season(season).find_all {|game_team| game_team.team_id == team_id && game_team.result == "WIN"}
  # end

  # def worst_season(team_id)
  #   @games_mngr.seasons.min_by {|season|team_season_win_percentage(team_id, season)}
  # end

  def average_win_percentage(team_id)
    @gt_mngr.average_win_percentage(team_id)
  end

  def most_goals_scored(team_id)
    goals_by_team_id = @gt_mngr.goals_by_team_id
    max_goals_by_team = goals_by_team_id[team_id].max
  end

  def fewest_goals_scored(team_id)
    goals_by_team_id = @gt_mngr.goals_by_team_id
    min_goals_by_team = goals_by_team_id[team_id].min
  end

  def opponent_win_percentages(home_team_id)
    games_with_team = @games_mngr.games_with_any_team_id(home_team_id)
    game_teams_of_games = @gt_mngr.game_teams_with_game_ids_mngr(games_with_team.game_ids_in_game_mngr)
    game_teams_of_opponents = game_teams_of_games.remove_team(home_team_id)
    game_teams_by_team_id = game_teams_of_opponents.game_teams_mngr_by_team_id
    opponent_win_percentages = Hash.new()
    game_teams_by_team_id.each do |team_id, gt_mngr|
      opponent_win_percentages[team_id] = gt_mngr.average_win_percentage(team_id)
    end
    opponent_win_percentages
  end

  def favorite_opponent(home_team_id)
    opponent_win_percentages = opponent_win_percentages(home_team_id)
    fav_opponent_id = opponent_win_percentages.min_by{|away_team_id, win_percentage| win_percentage}[0]
    fav_opponent = @teams_mngr.find_team_name(fav_opponent_id)
  end

  def rival(team_id)
    opponent_win_percentages = opponent_win_percentages(team_id)
    rival_id = opponent_win_percentages.max_by{|away_team_id, win_percentage| win_percentage}[0]
    rival = @teams_mngr.find_team_name(rival_id)
  end
  #### Season
  def winningest_coach(season)
    game_ids = @games_mngr.game_ids_in_games(@games_mngr.games_in_season(season))
    @gt_mngr.percentage_wins_by_coach(game_ids).max_by { |coach , average_wins| average_wins }[0]
  end

  def worst_coach(season)
    game_ids = @games_mngr.game_ids_in_games(@games_mngr.games_in_season(season))
    @gt_mngr.percentage_wins_by_coach(game_ids).min_by { |coach , average_wins| average_wins }[0]
  end
  # def game_teams_by_games(games)
  #    game_ids = @games_mngr.game_ids_in_games(games)
  #    @gt_mngr.game_teams.find_all{|game_team|game_ids.include?(game_team.game_id)}
  #  end

  #  def game_teams_in_season(season)
  #    games_in_season = @games_mngr.games_in_season(season)
  #    game_teams_in_season = game_teams_by_games(games_in_season)
  #  end

  def most_accurate_team(season)
    game_ids = @games_mngr.game_ids_in_games(@games_mngr.games_in_season(season))
    team_id = @gt_mngr.team_accuracy(game_ids).max_by {|team_id, accuracy| accuracy}.first
    @teams_mngr.find_team_name(team_id)
  end

  def least_accurate_team(season)
    game_ids = @games_mngr.game_ids_in_games(@games_mngr.games_in_season(season))
    team_id = @gt_mngr.team_accuracy(game_ids).min_by {|team_id, accuracy| accuracy}.first
    @teams_mngr.find_team_name(team_id)
  end

  def most_tackles(season)
    game_ids = @games_mngr.game_ids_in_games(@games_mngr.games_in_season(season))
    team_id = @gt_mngr.tackles(game_ids).max_by {|team_id, tackles| tackles}.first
    @teams_mngr.find_team_name(team_id)
  end

  def fewest_tackles(season)
    game_ids = @games_mngr.game_ids_in_games(@games_mngr.games_in_season(season))
    team_id = @gt_mngr.tackles(game_ids).min_by {|team_id, tackles| tackles}.first
    @teams_mngr.find_team_name(team_id)
  end
end
