require_relative './teams_manager'
require_relative './game_teams_manager'
require_relative './games_manager'
require_relative './statistics'

class StatTracker
  include Statistics
  attr_accessor :g_mngr, :t_mngr, :gt_mngr

  def initialize(locations)
    @g_mngr = GamesManager.from_csv(locations[:games])
    @t_mngr = TeamsManager.from_csv(locations[:teams])
    @gt_mngr = GameTeamsManager.from_csv(locations[:game_teams])
  end

  def self.from_csv(locations)
    stat_tracker = StatTracker.new(locations)
  end
  # Game Statistics Methods
  def highest_total_score
    @g_mngr.highest_total_score
  end

  def lowest_total_score
    @g_mngr.lowest_total_score
  end

  def percentage_visitor_wins
    (@g_mngr.total_visitor_wins / @g_mngr.total_games.to_f).round(2)
  end

  def percentage_home_wins
    (@g_mngr.total_home_wins / @g_mngr.total_games.to_f).round(2)
  end

  def percentage_ties
    (@g_mngr.total_ties / @g_mngr.total_games.to_f).round(2)
  end

  def count_of_games_by_season
    @g_mngr.count_of_games_by_season
  end

  def average_goals_per_game
    @g_mngr.average_goals_per_game
  end

  def average_goals_by_season
    @g_mngr.games_by_season.each_with_object({}) do |(s, games), games_by_s|
      games_by_s[s] = @g_mngr.average_goals_per_game(games)
    end
  end
  # League Statistics
  def count_of_teams
    @t_mngr.count_of_teams
  end

  def best_offense
    @t_mngr.find_team_name(best_key(@gt_mngr.offense))
  end

  def worst_offense
    @t_mngr.find_team_name(worst_key(@gt_mngr.offense))
  end

  def highest_scoring_visitor
    @t_mngr.find_team_name(best_key(@gt_mngr.scoring_visitor))
  end

  def lowest_scoring_visitor
    @t_mngr.find_team_name(worst_key(@gt_mngr.scoring_visitor))
  end

  def highest_scoring_home_team
    @t_mngr.find_team_name(best_key(@gt_mngr.scoring_home_team))
  end

  def lowest_scoring_home_team
    @t_mngr.find_team_name(worst_key(@gt_mngr.scoring_home_team))
  end
  #Team Statistics
  def team_info(team_id)
    @t_mngr.team_info(team_id)
  end

  def best_season(team_id)
    best_key(win_percentage_by_season(team_id))
  end

  def worst_season(team_id)
    worst_key(win_percentage_by_season(team_id))
  end

  def win_percentage_by_season(team_id)
    games_by_s = @g_mngr.games_by_season(@g_mngr.games_with_any_team_id(team_id))
    w_perc_by_s = games_by_s.each_with_object({}) do |(season, games), w_perc|
      gts = @gt_mngr.game_teams_with_game_ids(@g_mngr.game_ids_in_games(games))
      w_perc[season] = @gt_mngr.average_win_percentage(team_id, gts)
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

  def opponent_w_perc(team_id)
    @gt_mngr.opponent_w_perc(team_id)
  end

  def favorite_opponent(home_team_id)
    @t_mngr.find_team_name(worst_key(opponent_w_perc(home_team_id)))
  end

  def rival(team_id)
    @t_mngr.find_team_name(best_key(opponent_w_perc(team_id)))
  end
  #### Season
  def winningest_coach(season)
    best_key(@gt_mngr.percentage_wins_by_coach(@g_mngr.game_ids_in_s(season)))
  end

  def worst_coach(season)
    worst_key(@gt_mngr.percentage_wins_by_coach(@g_mngr.game_ids_in_s(season)))
  end

  def most_accurate_team(season)
    @t_mngr.find_team_name(best_key(@gt_mngr.team_accuracy(@g_mngr.game_ids_in_s(season))))
  end

  def least_accurate_team(season)
    @t_mngr.find_team_name(worst_key(@gt_mngr.team_accuracy(@g_mngr.game_ids_in_s(season))))
  end

  def most_tackles(season)
    @t_mngr.find_team_name(best_key(@gt_mngr.tackles(@g_mngr.game_ids_in_s(season))))
  end

  def fewest_tackles(season)
    @t_mngr.find_team_name(worst_key(@gt_mngr.tackles(@g_mngr.game_ids_in_s(season))))
  end
end
