require 'simplecov'
SimpleCov.start

require './lib/game_teams_manager'
require 'csv'

describe GameTeamsManager do
  before(:all) do
    @gtmngr = GameTeamsManager.from_csv('./data/game_teams.csv')
  end

  describe '#initialize' do
    it 'exists' do
      expect(@gtmngr).to be_an_instance_of(GameTeamsManager)
    end

    it 'has default values' do
      expect(@gtmngr.game_teams[0]).to be_an_instance_of(GameTeam)
      expect(@gtmngr.game_teams.count).to eq(14882)
    end

    it 'initializes correctly from a single GameTeam' do
      game_team = @gtmngr.game_teams[0]
      gtmngr1 = GameTeamsManager.new(game_team)
      expect(gtmngr1).to be_a(GameTeamsManager)
      expect(gtmngr1.game_teams).to be_a(Array)
      expect(gtmngr1.game_teams[0]).to be_a(GameTeam)
    end
    it 'initializes correctly from an array of GameTeams' do
      game_teams = @gtmngr.game_teams[0..5]
      gtmngr1 = GameTeamsManager.new(game_teams)
      expect(gtmngr1).to be_a(GameTeamsManager)
      expect(gtmngr1.game_teams).to be_a(Array)
      expect(gtmngr1.game_teams[0]).to be_a(GameTeam)
    end
  end

  describe '#offense' do
    it 'returns the team id for the highest average goals per game' do
      expect(@gtmngr.offense).to be_a(Hash)
    end
  end

  describe '#team_average_goals' do
    it 'creates a hash sorted by team id and average goals per game' do
      argument = @gtmngr.games_by_team([@gtmngr.game_teams[0], @gtmngr.game_teams[1]])
      expect(@gtmngr.team_average_goals(argument)).to be_a(Hash)
    end
  end

  describe ' #game_teams_mngr_by_team_id' do
    it 'creates a hash' do
      expect(@gtmngr.game_teams_mngr_by_team_id.class).to be(Hash)
    end
    it 'creates a hash with an GameTeamsManager object for every value' do
      expect(@gtmngr.game_teams_mngr_by_team_id.values.all?{|value| value.class == GameTeamsManager}).to eq(true)
    end
  end

  describe '#games_by_team' do
    it 'creates a hash sorted by team id and giving all game_team objects' do
      argument = [@gtmngr.game_teams[0], @gtmngr.game_teams[1]]
      expect(@gtmngr.games_by_team(argument).class).to be(Hash)
    end
  end

  describe ' #remove_team' do
    it 'returns an updated GameTeamsManager' do
      @game_ids = ['2012030221', '2012030222']
      @gt_mngr2 = @gtmngr.game_teams_with_game_ids_mngr(@game_ids)
      expect(@gt_mngr2.remove_team('3')).to be_a(GameTeamsManager)
    end
    it 'removes game_teams that meet given Id from game_team_manager' do
      @game_ids = ['2012030221', '2012030222']
      @gt_mngr2 = @gtmngr.game_teams_with_game_ids_mngr(@game_ids)
      expect(@gt_mngr2.game_teams.length).to eq(4)
      @gt_mngr2.remove_team('3')
      expect(@gt_mngr2.game_teams.length).to eq(2)
    end
  end
  describe ' #game_teams_with_game_ids' do
    before(:each) do
      @game_ids = ['2012030221', '2012030222']
      @game_teams = @gtmngr.game_teams_with_game_ids(@game_ids)
    end

    it 'returns an array' do
      expect(@game_teams).to be_a(Array)
    end
    it 'returns an array of GameTeams objects' do
      expect(@game_teams.all?{|game_team| game_team.class == GameTeam}).to be(true)
    end
  end

  describe ' #game_teams_with_game_ids_mngr' do
    before(:each) do
      @game_ids = ['2012030221', '2012030222']
      @gt_mngr2 = @gtmngr.game_teams_with_game_ids_mngr(@game_ids)
    end

    it 'returns a GameTeamsManager object' do
      expect(@gt_mngr2).to be_a(GameTeamsManager)
    end
    it 'returns a GameTeamsManager object with an array of GameTeams objects' do
      expect(@gt_mngr2.game_teams.all?{|game_team| game_team.class == GameTeam}).to be(true)
    end
  end

  describe '#total_games' do
    it 'sums the number of games for the game teams passed in' do
      expect(@gtmngr.total_games([@gtmngr.game_teams[0]])).to be(1)
    end
  end

  describe '#total_goals' do
    it 'adds up all the goals for the game_teams passed in' do
      argument = [@gtmngr.game_teams[0], @gtmngr.game_teams[1]]
      expect(@gtmngr.total_goals(argument)).to be(5)
    end
  end

  describe '#average_goals' do
    it 'finds the average goals per game for the game_teams passed in' do
      argument = [@gtmngr.game_teams[0], @gtmngr.game_teams[1]]
      expect(@gtmngr.average_goals(argument)).to eq(2.5000)
    end
  end

  describe '#scoring_visitor' do
    it 'returns the team with the highest average goals as a visitor' do
      expect(@gtmngr.scoring_visitor).to be_a(Hash)
    end
  end

  describe '#highest_scoring_home_team' do
    it 'returns the team with the highest average goals as a visitor' do
      expect(@gtmngr.scoring_home_team).to be_a(Hash)
    end
  end

  describe '#away_games' do
    it 'finds all of the away games' do
      expect(@gtmngr.away_games.count).to eq(7441)
    end
  end

  describe '#home_games' do
    it 'finds all of the home games' do
      expect(@gtmngr.home_games.count).to eq(7441)
    end
  end

  describe '#average_win_percentage' do
    it 'returns the hash of seasons and the win percentage' do
      expect(@gtmngr.average_win_percentage("6")).to eq(0.49)
    end
  end

  describe ' #goals_by_team_id' do
    it 'returns a hash' do
      expect(@gtmngr.goals_by_team_id).to be_a(Hash)
    end
    it 'returns a hash with arrays as values' do
      expect(@gtmngr.goals_by_team_id.values.all?{|value| value.class == Array}).to eq(true)
    end
    it 'returns a hash with an array of integers' do
      expect(@gtmngr.goals_by_team_id.values.flatten.all?{|value| value.class == Integer}).to eq(true)
    end
  end

  describe '#team_accuracy' do
    it 'returns a hash with the team id and accuracy' do
      game_path = './data/games_test.csv'
      team_path = './data/teams.csv'
      game_teams_path = './data/game_teams_test.csv'

      locations = {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }

      @stat_tracker = StatTracker.from_csv(locations)
      expected = {"3"=>0.2353, "5"=>0.0, "6"=>0.3333}
      expect(@gtmngr.team_accuracy(["2012030221", "2012030222", "2012030311"])).to eq(expected)
    end
  end

  describe '#tackles' do
    it 'returns a hash with the team id and most tackles' do
      expected = {"3"=> 77, "5"=>34, "6"=>106}
      expect(@gtmngr.tackles(["2012030221", "2012030222", "2012030311"])).to eq(expected)
    end
  end
end
