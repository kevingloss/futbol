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
    @games_mngr.games_by_season.each_with_object({}) do |(s, games), games_by_s|
      games_by_s[s] = @games_mngr.average_goals_per_game(games)
    end
  end
  # League Statistics
  def count_of_teams
    @teams_mngr.count_of_teams
  end

  def best_offense
    @teams_mngr.find_team_name(best_key(@gt_mngr.offense))
  end

  def worst_offense
    @teams_mngr.find_team_name(worst_key(@gt_mngr.offense))
  end

  def highest_scoring_visitor
    @teams_mngr.find_team_name(best_key(@gt_mngr.scoring_visitor))
  end

  def lowest_scoring_visitor
    @teams_mngr.find_team_name(worst_key(@gt_mngr.scoring_visitor))
  end

  def highest_scoring_home_team
    @teams_mngr.find_team_name(best_key(@gt_mngr.scoring_home_team))
  end

  def lowest_scoring_home_team
    @teams_mngr.find_team_name(worst_key(@gt_mngr.scoring_home_team))
  end
  #Team Statistics
  def team_info(team_id)
    @teams_mngr.team_info(team_id)
  end

  def best_season(team_id)
    best_key(win_percentage_by_season(team_id))
  end

  def worst_season(team_id)
    worst_key(win_percentage_by_season(team_id))
  end

  def win_percentage_by_season(team_id)
    games_by_s = @games_mngr.games_by_season(@games_mngr.games_with_any_team_id(team_id))
    w_perc_by_s = games_by_s.each_with_object({}) do |(season, games), w_perc|
      w_perc[season] = @gt_mngr.average_win_percentage(team_id, game_teams_by_games(games))
    end
  end

  def average_win_percentage(team_id)
    @gt_mngr.average_win_percentage(team_id)
  end

  def most_goals_scored(team_id)
    @gt_mngr.goals_by_team_id[team_id].max
  end

  def fewest_goals_scored(team_id)
    @gt_mngr.goals_by_team_id[team_id].min
  end

  def opponent_w_perc(home_team_id)
    games_w_t = @games_mngr.games_with_any_team_id(home_team_id)
    gts_of_games = @gt_mngr.gt_w_game_ids_mngr(games_w_t.game_ids_in_game_mngr)
    gts_of_opp = gts_of_games.remove_team(home_team_id)
    gts_by_team_id = gts_of_opp.game_teams_mngr_by_team_id
    owp = gts_by_team_id.each_with_object({}) do |(team_id, gt_mngr), owp|
      owp[team_id] = gt_mngr.average_win_percentage(team_id)
    end
  end

  def favorite_opponent(home_team_id)
    @teams_mngr.find_team_name(worst_key(opponent_w_perc(home_team_id)))
  end

  def rival(team_id)
    @teams_mngr.find_team_name(best_key(opponent_w_perc(team_id)))
  end
  #### Season
  def winningest_coach(season)
    game_ids = @games_mngr.game_ids_in_games(@games_mngr.games_in_season(season))
    best_key(@gt_mngr.percentage_wins_by_coach(game_ids))
  end

  def worst_coach(season)
    game_ids = @games_mngr.game_ids_in_games(@games_mngr.games_in_season(season))
    worst_key(@gt_mngr.percentage_wins_by_coach(game_ids))
  end

  def game_teams_by_games(games)
    game_ids = @games_mngr.game_ids_in_games(games)
    @gt_mngr.game_teams.find_all{|game_team|game_ids.include?(game_team.game_id)}
  end

  def game_teams_in_season(season)
    games_in_season = @games_mngr.games_in_season(season)
    game_teams_in_season = game_teams_by_games(games_in_season)
  end

  def most_accurate_team(season)
    game_ids = @games_mngr.game_ids_in_games(@games_mngr.games_in_season(season))
    @teams_mngr.find_team_name(best_key(@gt_mngr.team_accuracy(game_ids)))
  end

  def least_accurate_team(season)
    game_ids = @games_mngr.game_ids_in_games(@games_mngr.games_in_season(season))
    @teams_mngr.find_team_name(worst_key(@gt_mngr.team_accuracy(game_ids)))
  end

  def most_tackles(season)
    game_ids = @games_mngr.game_ids_in_games(@games_mngr.games_in_season(season))
    @teams_mngr.find_team_name(best_key(@gt_mngr.tackles(game_ids)))
  end

  def fewest_tackles(season)
    game_ids = @games_mngr.game_ids_in_games(@games_mngr.games_in_season(season))
    @teams_mngr.find_team_name(worst_key(@gt_mngr.tackles(game_ids)))
  end
end
