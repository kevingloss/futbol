# require 'csv'
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

  # A hash with season names (e.g. 20122013) as keys and counts of games as values
  def count_of_games_by_season
    count_of_games_by_season = @games_mngr.count_of_games_by_season
  end

  # Average number of goals scored in a game across all seasons including
  # both home and away goals (rounded to the nearest 100th) - float
  def average_goals_per_game
    avg_goals_per_game = @games_mngr.average_goals_per_game
  end

  # Average number of goals scored in a game organized in a hash
  # with season names (e.g. 20122013) as keys and a float
  # representing the average number of goals in a game for that season
  # as values (rounded to the nearest 100th)	- Hash
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

  # Methods between lines 123 & 150 are used with best_offense/worst_offense
  # calculating goals across all seasons for a team
# best offense will need:
  # all games played by a team
  # average goals scored per game
    #total goals scored per game / total games played
  #could use a hash and do team_id => game_teams array

  #would only call game_teams_mng then team_mngr for team name from id #
  def best_offense
    @teams_mngr.find_team_name(@gt_mngr.best_offense)
  end

  def worst_offense
    @teams_mngr.find_team_name(@gt_mngr.worst_offense)
  end

  #Lines 153 to 200 use these methods to find teh highest/lowest scoring teams
  #based on being the home or away team
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
    @teams.find {|team| team.team_id == team_id}
  end

  def best_season(team_id)
    @games_mngr.seasons.max_by do |season|
      team_season_win_percentage(team_id, season) #pass in two arguments and include the season?
    end
  end

  def best_season_mngr(team_id)
    # get all games of team
    # create games_manager objects by season
    # analyze win percentage of each season
    # return best
    games_with_team = @games_mngr.games_with_home_team_id(team_id)


    @games_mngr.seasons.max_by do |season|
      team_season_win_percentage(team_id, season) #pass in two arguments and include the season?
    end
  end


  def team_season_win_percentage(team_id, season)
    # return 0 if team_games_by_season(team_id, season).count == 0

    #this line is returning an infinity when there are zero games in a season
    season_wins(team_id, season).count/team_games_by_season(team_id, season).count.to_f
  end

  #this is going through the games and not game_teams where the wins are saved
  def team_games_by_season(team_id, season)
    seasons_games = games_in_season(season)
    team_games_in_season = seasons_games.find_all do |game|
      game.away_team_id == team_id || game.home_team_id == team_id
    end
  end

  #this method was just searching all the game_teams originally, need to limit it
  #changed to Leland's helper method to sort by games in season
  def season_wins(team_id, season)
    game_teams_in_season(season).find_all {|game_team| game_team.team_id == team_id && game_team.result == "WIN"}
  end

  def worst_season(team_id)
    @games_mngr.seasons.min_by {|season|team_season_win_percentage(team_id, season)}
  end

  def average_win_percentage(team_id)
    @gt_mngr.average_win_percentage(team_id)
  end

  # Highest number of goals a particular team has scored in a single game.
  def most_goals_scored(team_id)
    goals_by_team_id = @gt_mngr.goals_by_team_id
    max_goals_by_team = goals_by_team_id[team_id].max
  end

  def fewest_goals_scored(team_id)
    goals_by_team_id = @gt_mngr.goals_by_team_id
    min_goals_by_team = goals_by_team_id[team_id].min
  end

  #given a team_id, return a hash of the win percentages of all opponents
  def opponent_win_percentages(home_team_id)
    games_with_team = @games_mngr.games_with_any_team_id(home_team_id)
    game_teams_of_games = @gt_mngr.game_teams_with_game_ids(games_with_team.game_ids_in_game_mngr)
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
    average_wins_by_coach(season).max_by { |coach , average_wins| average_wins }[0]
  end

  def game_teams_by_coaches(season)
    game_teams_by_coach = game_teams_in_season(season).group_by { |game_teams| game_teams.head_coach}
  end

  def average_wins_by_coach(season)
    average_percent_won_by_coaches = Hash.new
    game_teams_by_coaches(season).each do |coach , game_teams|
      total_wins_by_coach = game_teams.find_all{ |game_team| game_team.result == 'WIN'}.count.to_f
      average_percent_won_by_coaches[coach] = total_wins_by_coach / game_teams.count.to_f
      end
    average_percent_won_by_coaches
  end

  def worst_coach(season)
    average_wins_by_coach(season).min_by { |coach , average_wins| average_wins }[0]
  end

  # accept an array of game teams and return a single accuracy score
  # def accuracy(game_teams)
  #   total_goals = game_teams.map{|game_team| game_team.goals}.sum.to_f
  #   total_shots = game_teams.map{|game_team| game_team.shots}.sum.to_f
  #   accuracy = total_goals/total_shots
  # end

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

  # def game_teams_by_games(games)
  #   game_ids = @games_mngr.game_ids_in_games(games)
  #   @gt_mngr.game_teams.find_all{|game_team|game_ids.include?(game_team.game_id)}
  # end
  # helper method to collect all game_teams in a given season
  # def game_teams_in_season(season)
  #   games_in_season = @games_mngr.games_in_season(season)
  #   game_teams_in_season = game_teams_by_games(games_in_season)
  # end

  # return an array of team names from an array of team objects, or a single team name if only one given
  # def teams_from_game_teams(game_teams)
  #   # if single team, return single value. Else return array of values.
  #
  #   # get team ids from selected game_teams, and use this to gather the team names.
  #   team_ids =  game_teams.map { |game_team| game_team.team_id }
  #   teams = @teams.select{ |team| team_ids.include?(team.team_id) } # this can be faster with a hash.
  #   return teams
  # end

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
