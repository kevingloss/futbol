# require 'csv'
require_relative './teams_manager'
require_relative './game_teams_manager'
require_relative './games_manager'

class StatTracker
  attr_accessor :games_mngr, :teams_mngr, :gt_mngr

  def initialize(locations)
    @games_mngr = GamesManager.new(locations[:games])
    @teams_mngr = TeamsManager.new(locations[:teams])
    @gt_mngr = GameTeamsManager.new(locations[:game_teams])
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
    visitor_wins = []
    @games.each do |game|
      visitor_wins.push(game) if game.away_goals > game.home_goals
    end
    (visitor_wins.count.to_f / @games.count.to_f).round(2)
  end

  def percentage_home_wins
    home_wins = []
    @games.each do |game|
      home_wins.push(game) if game.home_goals > game.away_goals
    end
    (home_wins.count.to_f / @games.count.to_f).round(2)
  end

  def percentage_ties
    tie_games = []
    @games.each do |game|
      tie_games.push(game) if game.home_goals == game.away_goals
    end
    (tie_games.count.to_f / @games.count.to_f).round(2)
  end

  # A hash with season names (e.g. 20122013) as keys and counts of games as values
  def count_of_games_by_season
    count_of_games_by_season = Hash.new(0)
    games_by_season = @games.group_by { |game| game.season }
    games_by_season.keys.each do |season|
      count_of_games_by_season[season] = games_by_season[season].length
    end
    count_of_games_by_season
  end

  # Average number of goals scored in a game across all seasons including
  # both home and away goals (rounded to the nearest 100th) - float
  def average_goals_per_game
    total_goals = @games.map { |game| game.home_goals + game.away_goals }
    avg_goals_per_game = (total_goals.sum.to_f / total_goals.length.to_f).round(2)
  end

  # Average number of goals scored in a game organized in a hash
  # with season names (e.g. 20122013) as keys and a float
  # representing the average number of goals in a game for that season
  # as values (rounded to the nearest 100th)	- Hash
  def average_goals_by_season
    avg_goals_by_season = Hash.new(0)
    games_by_season = @games.group_by{|game|game.season}
    games_by_season.each do |season, games|
      total_goals = games.map{|game| game.away_goals + game.home_goals}.sum
      avg_goals = (total_goals/games.count.to_f)
      avg_goals_by_season[season] = avg_goals.round(2)
    end
    return avg_goals_by_season
  end

  # League Statistics
  def count_of_teams
    @teams.count
  end

  # Methods between lines 123 & 150 are used with best_offense/worst_offense
  # calculating goals across all seasons for a team
  def best_offense
    @teams.max_by do |team|
      average_goals(team)
    end.team_name
  end

  def worst_offense
    @teams.min_by do |team|
      average_goals(team)
    end.team_name
  end

  # average goals across all games
  def average_goals(team)
    all_games = team_games(team)
    return 0 if all_games.empty?

    total_goals(all_games) / all_games.count.to_f
  end

  # finds all games a team plays in, and returns that array
  def team_games(team)
    @game_teams.find_all do |game|
      game.team_id == team.team_id
    end
  end

  # sums the goals for all games of a team
  def total_goals(all_games)
    all_games.sum { |game| game.goals }
  end

  #Lines 153 to 200 use these methods to find teh highest/lowest scoring teams
  #based on being the home or away team
  def highest_scoring_visitor
    @teams.max_by do |team|
      visiting_average_goals(team)
    end.team_name
  end

  def visiting_team_games(team)
    @game_teams.find_all do |game|
      game.team_id == team.team_id && game.h_o_a == 'away'
    end
  end

  def visiting_average_goals(team)
    visiting_games = visiting_team_games(team)
    return 0 if visiting_games.empty?

    total_goals(visiting_games) / visiting_games.count.to_f
  end

  def highest_scoring_home_team
    @teams.max_by do |team|
      home_average_goals(team)
    end.team_name
  end

  def home_team_games(team)
    @game_teams.find_all do |game|
      game.team_id == team.team_id && game.h_o_a == 'home'
    end
  end

  def home_average_goals(team)
    home_games = home_team_games(team)
    return 0 if home_games.empty?

    total_goals(home_games) / home_games.count.to_f
  end

  def lowest_scoring_visitor
    @teams.min_by do |team|
      visiting_average_goals(team)
    end.team_name
  end

  def lowest_scoring_home_team
    @teams.min_by do |team|
      home_average_goals(team)
    end.team_name
  end


  #Team Statistics
  def team_info(team_id)
    team = find_team(team_id)
    {
      "team_id" => team.team_id,
      "franchise_id" => team.franchise_id,
      "team_name" => team.team_name,
      "abbreviation" => team.abbreviation,
      "link" => team.link
    }
    # categories = team.keys
    # info = team.values
    # Hash[categories.zip(info)]
  end

  def find_team(team_id)
    @teams.find {|team| team.team_id == team_id}
  end

  def best_season(team_id)
    seasons.max_by do |season|
      team_season_win_percentage(team_id, season) #pass in two arguments and include the season?
    end
  end

  def seasons
    @games.map {|game| game.season}.uniq
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
    game_teams_in_season(season).find_all do |game_team|
    # @game_teams
      game_team.team_id == team_id && game_team.result == "WIN"
    end
  end

  def worst_season(team_id)
    seasons.min_by do |season|
      team_season_win_percentage(team_id, season)
    end
  end

  def average_win_percentage(team_id)
    away_games = @games.find_all do |game|
      team_id == game.away_team_id
    end
    away_game_wins = away_games.find_all do |game|
      game.away_goals > game.home_goals
    end.size

    home_games = @games.find_all do |game|
      team_id == game.home_team_id
    end
    home_game_wins = home_games.find_all do |game|
      game.away_goals < game.home_goals
    end.size
    percentage = (away_game_wins + home_game_wins).to_f / (away_games.size + home_games.size).to_f
    percentage.round(2)
  end

  def most_goals_scored(team_id)
    total = []
    away_games = @games.find_all do |game|
      team_id == game.away_team_id
    end
    home_games = @games.find_all do |game|
      team_id == game.home_team_id
    end
    total << away_games = away_games.map { |game| game.away_goals }.max
    total << home_games = home_games.map { |game| game.home_goals }.max
    total.max
  end

  def fewest_goals_scored(team_id)
    total = []
    away_games = @games.find_all do |game|
      team_id == game.away_team_id
    end
    home_games = @games.find_all do |game|
      team_id == game.home_team_id
    end
    total << away_games = away_games.map { |game| game.away_goals }.min
    total << home_games = home_games.map { |game| game.home_goals }.min
    total.min
  end

  #given a team_id, return a hash of the win percentages of all opponents
  def opponent_win_percentages(team_id)
    # get all games of a particular team
    # sort by opponent id
    # iterates through games by opponent
    # count wins and losses, return win percentage
    # return opponent with lowest win percentage
    games_with_team = @games.find_all{|game| game.home_team_id == team_id}
    games_by_away_team = games_with_team.group_by{|game| game.away_team_id}
    opponent_win_percentages = Hash.new()
    games_by_away_team.each do |away_team_id, games|
      # how should we deal with ties?
      wins = games.find_all{|game| game.home_goals > game.away_goals}.count.to_f
      total = games.count.to_f
      win_percentage = wins/total
      team_name = @teams.select{|team| team.team_id == away_team_id}[0].team_name
      opponent_win_percentages[team_name] = win_percentage
    end
    opponent_win_percentages
  end

  def favorite_opponent(team_id)
    opponent_win_percentages = opponent_win_percentages(team_id)
    fav_opponent = opponent_win_percentages.min_by{|away_team_name, win_percentage| win_percentage}[0]
  end

  def rival(team_id)
    opponent_win_percentages = opponent_win_percentages(team_id)
    rival = opponent_win_percentages.max_by{|away_team_name, win_percentage| win_percentage}[0]
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
      total_wins = game_teams.find_all{ |game_team| game_team.result == 'WIN'}.count.to_f
      average_percent_won_by_coaches[coach] = total_wins / game_teams.count.to_f
      end
    average_percent_won_by_coaches
  end

  def worst_coach(season)
    average_wins_by_coach(season).min_by { |coach , average_wins| average_wins }[0]
  end


  # accept an array of game teams and return a single accuracy score
  def accuracy(game_teams)
    total_goals = game_teams.map{|game_team| game_team.goals}.sum.to_f
    total_shots = game_teams.map{|game_team| game_team.shots}.sum.to_f
    accuracy = total_goals/total_shots
  end

  def most_accurate_team(season)
    # get all games in season
    # get game_teams in games
    # group_by game_teams by team_id.
    # iterate through each team - work on array of game_teams
    # sum all goals, sum all shots, calculate single accuracy score
    game_teams_in_season = game_teams_in_season(season)
    game_teams_by_team = game_teams_in_season.group_by{|game_team| game_team.team_id}
    accuracy_hash = Hash.new()
    game_teams_by_team.each do |team_id, game_teams|
      accuracy = accuracy(game_teams)
      accuracy_hash[team_id] = accuracy
    end
    max_team_id = accuracy_hash.max_by{|team_id, accuracy| accuracy}[0]
    max_team = @teams.select{ |team| team.team_id == max_team_id}[0]
    max_team_name = max_team.team_name
  end

  def least_accurate_team(season)
    game_teams_in_season = game_teams_in_season(season)
    game_teams_by_team = game_teams_in_season.group_by{|game_team| game_team.team_id}
    accuracy_hash = Hash.new()
    game_teams_by_team.each do |team_id, game_teams|
      accuracy = accuracy(game_teams)
      accuracy_hash[team_id] = accuracy
    end
    min_team_id = accuracy_hash.min_by{|team_id, accuracy| accuracy}[0]
    min_team = @teams.select{ |team| team.team_id == min_team_id}[0]
    min_team_name = min_team.team_name
  end

  def games_in_season(season)
    games_in_season = @games.find_all { |game| game.season == season }
  end

  def game_ids_in_games(games)
    game_ids_in_games = games.map { |game| game.game_id }
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

  def team_from_game_team(game_team)
    # get team id from selected game_team, and use this to gather the team name.
    team_id =  game_team.team_id
    team = @teams.select{|team| team.team_id == team_id} #this can be faster with a hash
    return team[0]
  end

  # return an array of team names from an array of team objects, or a single team name if only one given
  def teams_from_game_teams(game_teams)
    # if single team, return single value. Else return array of values.

    # get team ids from selected game_teams, and use this to gather the team names.
    team_ids =  game_teams.map { |game_team| game_team.team_id }
    teams = @teams.select{ |team| team_ids.include?(team.team_id) } # this can be faster with a hash.
    return teams
  end

  # Name of the Team with the most tackles in the season	- String
  def most_tackles(season)
    game_teams_in_season = game_teams_in_season(season)
    max_tackles_game_team = game_teams_in_season.max_by{ |game_team|game_team.tackles}
    max_tackles = max_tackles_game_team.tackles
    max_tackles_game_teams = game_teams_in_season.select{|game_team| game_team.tackles == max_tackles}
    teams = teams_from_game_teams(max_tackles_game_teams)
    team_names = teams.map { |team| team.team_name }
    # return sigle name if only one item.
    if team_names.length == 1
      team_names[0]
    else
      team_names
    end
  end

  # Name of the Team with the fewest tackles in the season	- String
  def fewest_tackles(season)
    game_teams_in_season = game_teams_in_season(season)
    min_tackles_game_team = game_teams_in_season.min_by{ |game_team|game_team.tackles}
    min_tackles = min_tackles_game_team.tackles
    min_tackles_game_teams = game_teams_in_season.select{|game_team| game_team.tackles == min_tackles}
    teams = teams_from_game_teams(min_tackles_game_teams)
    team_names = teams.map { |team| team.team_name }
    # return sigle name if only one item.
    if team_names.length == 1
      team_names[0]
    else
      team_names
    end
  end
end
