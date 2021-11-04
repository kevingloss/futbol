require 'simplecov'
SimpleCov.start

require './lib/stat_tracker'

RSpec.describe StatTracker do
  # before(:all) do
  #   game_path = './data/games.csv'
  #   team_path = './data/teams.csv'
  #   game_teams_path = './data/game_teams.csv'
  #
  #   locations = {
  #     games: game_path,
  #     teams: team_path,
  #     game_teams: game_teams_path
  #   }
  #
  #   @stat_tracker = StatTracker.from_csv(locations)
  # end

  before(:all) do
    game_path = './data/games_test.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams_test.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }

    @stat_tracker = StatTracker.from_csv(locations)
  end

  describe '#initialize' do
    it 'exists' do
      expect(@stat_tracker).to be_an_instance_of(StatTracker)
    end

    it 'has attributes' do
      expect(@stat_tracker.games).to be_a(Array)
      expect(@stat_tracker.teams).to be_a(Array)
      expect(@stat_tracker.game_teams).to be_a(Array)
    end
  end

  describe '::from_csv' do
    describe 'returns a StatTracker object' do
      it 'exists' do
        expect(@stat_tracker).to be_an_instance_of(StatTracker)
      end

      it 'has correct attributes and classes' do
        expect(@stat_tracker.games).to be_a(Array)
        expect(@stat_tracker.teams).to be_a(Array)
        expect(@stat_tracker.game_teams).to be_a(Array)
        expect(@stat_tracker.games[0]).to be_a(Games)
        expect(@stat_tracker.teams[0]).to be_a(Teams)
        expect(@stat_tracker.game_teams[0]).to be_a(GameTeams)
      end
    end
  end

  # Game Statistics Methods

  describe '#highest_total_score' do
    it 'will find the highest sum of the team scores from all the games' do
      expect(@stat_tracker.highest_total_score).to eq(6)
    end
  end
  describe '#lowest_total_score' do
    it 'will find the lowest sum of the team scores from all the games' do
      expect(@stat_tracker.lowest_total_score).to eq(2)
    end
  end

  describe 'percentage wins' do
    it 'finds the percentage of visitor wins' do
      expect(@stat_tracker.percentage_visitor_wins).to eq(0.29)
    end
    it 'finds the percentage of home wins' do
      expect(@stat_tracker.percentage_home_wins).to eq(0.43)
    end
  end

  describe '#percentage of ties' do
    it 'checks the percentage of games that are ties' do
      expect(@stat_tracker.percentage_ties).to eq(0.29)
    end
  end
  describe ' #count_of_games_by_season' do
    it 'returns a hash with correct count of games per season' do
      expect(@stat_tracker.count_of_games_by_season).to be_a(Hash)
      expect(@stat_tracker.count_of_games_by_season).to eq({ '20122013' => 6, '20142015' => 15 })
    end
  end
  describe ' #average_goals_per_game' do
    it 'returns the average # of goals per game' do
      expect(@stat_tracker.average_goals_per_game).to eq(3.86)
    end
  end
  describe ' #average_goals_per_season' do
    xit 'returns a hash with average # of goals per season' do
      expect(@stat_tracker.average_goals_per_season).to be_a(Hash)
      expect(@stat_tracker.average_goals_per_season).to eq({ '20122013' => 3.83, '20142015' => 3.87 })
    end
  end

  # League Stat
  describe '#count_of_teams' do
    it 'counts the total number of teams' do
      expect(@stat_tracker.count_of_teams).to eq(@stat_tracker.teams.count)
    end
  end

  describe '#best_offense' do
    it 'uses the #average_goals method' do
      team = @stat_tracker.teams[5]
      expect(@stat_tracker.average_goals(team)).to eq(2)
    end

    it 'returns the team name with the highest average goals per game across seasons' do
      expect(@stat_tracker.best_offense).to eq('FC Dallas')
    end
  end

  describe '#worst_offense' do
    it 'returns the team with the lowest average goals per game across seasons' do
      expect(@stat_tracker.worst_offense).to eq("Atlanta United")
      allow(@stat_tracker).to receive(:worst_offense).and_return('New York Red Bulls')
      expect(@stat_tracker.worst_offense).to eq('New York Red Bulls')
    end
  end

  describe '#highest_scoring_visitor' do
    it 'finds all the visiting games for a team' do
      team = @stat_tracker.teams[5]
      expect(@stat_tracker.visiting_team_games(team).count).to eq(2)
    end

    it 'returns the highest average scoring visitor team name' do
      expect(@stat_tracker.highest_scoring_visitor).to eq('New York City FC')
    end
  end

  describe '#highest_scoring_home_team' do
    it 'finds all the visiting games for a team' do
      team = @stat_tracker.teams[4]
      expect(@stat_tracker.home_team_games(team).count).to eq(2)
    end

    it 'returns the highest average scoring home team name' do
      expect(@stat_tracker.highest_scoring_home_team).to eq('FC Dallas')
    end
  end

  describe '#lowest_scoring_visitor' do
    it 'returns the lowest average scoring visitor team name' do
      expect(@stat_tracker.lowest_scoring_visitor).to eq('Atlanta United')
    end
  end

  describe '#lowest_scoring_home_team' do
    it 'returns the lowest average scoring home team name' do
      expect(@stat_tracker.lowest_scoring_home_team).to eq('Atlanta United')
    end
  end

  #Team Statistics - each method takes a team_id as an argument
  describe '#team_info' do
    it '#find_team - can find a team by team_id' do
      expect(@stat_tracker.find_team("15")).to eq(@stat_tracker.teams[15])
    end

    it 'returns a hash with key/values for all team attributes' do
      expected = {
        team_id: "15",
        franchise_id: "24",
        team_name: "Portland Timbers",
        abbreviation: "POR",
        stadium: "Providence Park",
        link:"/api/v1/teams/15"
      }

      expect(@stat_tracker.team_info("15")).to eq(expected)
    end
  end

  describe '#team_games_by_season' do
    it 'returns all games played in a season for a given team' do
      expected = [@stat_tracker.games[18]]
      expect(@stat_tracker.team_games_by_season("8", "20142015")).to eq(expected)
    end
  end

  describe '#seasons' do
    it 'returns all the seasons games have been played' do
      expect(@stat_tracker.seasons).to eq(["20122013", "20142015"])
    end
  end

  describe '#best_season' do
    it 'returns the season with the highest win percentage for a team' do
      expect(@stat_tracker.best_season("6")).to eq("20122013")
    end
  end

  describe '#worst_season' do
    it 'returns the season with the lowest win percentage for a team' do
      expect(@stat_tracker.best_season("6")).to eq("20122013")
    end
  end

  describe '#average_win_percentage' do
    it 'returns average percentage for a team' do
      expect(@stat_tracker.average_win_percentage('30')).to eq(10)
    end
  end

  describe '#most_goals_scored' do
    it 'returns a teams most goals scored in a game' do
      expect(@stat_tracker.most_goals_scored('30')).to eq(3)
    end
  end
  describe '#fewest_goals_scored' do
    it 'returns a teams most goals scored in a game' do
      expect(@stat_tracker.most_goals_scored('30')).to eq(3)
    end
  end

  describe '#rival' do
    xit '' do
    end
  end

  describe '#rival' do
    xit '' do
    end
  end
  ### Season
  describe '#winningest_coach' do
    it "checks the ins by seasons" do
      expect(@stat_tracker.wins_by_season('20122013')).to be_a(Array)
    end
    it "checks for the winning coaches to be an Array" do
      expect(@stat_tracker.wins_per_coaches('20122013')).to be_a(Hash)
    end
    it "gets the total games played by coaches" do
      expect(@stat_tracker.total_games_by_coaches('20122013')).to be_an(Hash)
    end
    it "finds the average of the coach" do
      expect(@stat_tracker.average_wins_by_coach('20122013')).to be_an(Hash)
    end

    it 'Name of the Coach with the best win percentage for the season' do
      expect(@stat_tracker.winningest_coach('20122013')).to be_a(String)
    end
  end
  describe '#worst_coach' do
    it 'Name of the Coach with the worst win percentage for the season' do
      expect(@stat_tracker.winningest_coach('20122013')).to be_a(String)
    end
  end
  describe ' #accuracy' do
    it 'accepts an array of game_teams and returns a single accuracy score' do
      game_teams1 = @stat_tracker.game_teams[0..4]
      expect(@stat_tracker.accuracy(game_teams1)).to eq(13.0/43.0)
    end
  end
  describe ' #most_accurate_team' do
    it 'returns the name of the team with the best ratio of shots to goals for the season' do
    expect(@stat_tracker.most_accurate_team('20122013')).to eq('FC Dallas')
  end
  end
  describe ' #least_accurate_team' do
    it 'returns the name of the team with the worst ratio of shots to goals for the season' do
    expect(@stat_tracker.least_accurate_team('20122013')).to eq('Houston Dynamo')
  end
  end
  describe ' #games_in_season' do
    it 'returns an array and games' do
      expect(@stat_tracker.games_in_season('20122013').all?{|game| game.class == Games}).to eq(true)
    end
  end
  describe ' #game_ids_in_games' do
    it 'returns an array of game ids for each input game' do
      game1 = @stat_tracker.games[0]
      games2 = @stat_tracker.games[0..2]
      expect(@stat_tracker.game_ids_in_games([game1])).to eq(['2012030221'])
      expect(@stat_tracker.game_ids_in_games(games2)).to eq(['2012030221','2012030222','2012030223'])
    end
  end
  describe ' #game_teams_by_games' do
    it 'returns all game_team associated with single input game' do
      game1 = @stat_tracker.games[0]
      game_teams1 = [@stat_tracker.game_teams[0], @stat_tracker.game_teams[2]]
      expect(@stat_tracker.game_teams_by_games([game1])).to eq(game_teams1)
    end
    it 'returns all game_teams associated with multiple input games' do
      games2 = @stat_tracker.games[0..1]
      game_teams2 = @stat_tracker.game_teams[0..3]
      expect(@stat_tracker.game_teams_by_games(games2)).to eq(game_teams2)
    end
  end
  describe ' #game_teams_in_season' do
    it 'returns an array of all of the game_teams that are a part of the selected season' do
      expect(@stat_tracker.game_teams_in_season('20122013')).to be_a(Array)
      expect(@stat_tracker.game_teams_in_season('20122013').length).to eq(4)
    end
  end
  describe 'team_from_game_team' do
    it 'returns a single team name for a single game_team given' do
      game_team1 = @stat_tracker.game_teams[0]
      team1 = @stat_tracker.teams[5]
      expect(@stat_tracker.team_from_game_team(game_team1)).to eq(team1)
    end
  end
  describe 'teams_from_game_teams' do
    it 'returns an array of teams for an array of game_team objects' do
      game_team1 = @stat_tracker.game_teams[0]
      team1 = @stat_tracker.teams[5]
      game_teams2 = @stat_tracker.game_teams[0..3]
      teams2 = [@stat_tracker.teams[4], @stat_tracker.teams[5]]
      expect(@stat_tracker.teams_from_game_teams([game_team1])).to eq([team1])
      expect(@stat_tracker.teams_from_game_teams(game_teams2)).to eq(teams2)
    end
  end
  describe ' #most_tackles' do
    it 'returns the name of the team with the most tackles in the season' do
      expect(@stat_tracker.most_tackles('20122013')).to eq('FC Dallas')
    end
  end
  describe '  #fewest_tackles' do
    it 'returns the name of the team with the fewest tackles in the season' do
      expect(@stat_tracker.fewest_tackles('20122013')).to eq('Houston Dynamo')
    end
  end
end
