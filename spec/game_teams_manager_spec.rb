require 'simplecov'
SimpleCov.start

require './lib/game_teams_manager'
require 'csv'

describe GameTeamsManager do
  before(:all) do
    @gtmngr = GameTeamsManager.new('./data/game_teams.csv')
  end

  describe '#initialize' do
    it 'exists' do
      expect(@gtmngr).to be_an_instance_of(GameTeamsManager)
    end

    it 'has default values' do
      expect(@gtmngr.game_teams[0]).to be_an_instance_of(GameTeam)
      expect(@gtmngr.game_teams.count).to eq(14882)
    end
  end

  describe '#best_offense' do
    it 'returns the team id for the highest average goals per game' do
      expect(@gtmngr.best_offense).to eq("54")
    end
  end

  describe '#worst_offense' do
    it 'returns the team id for the lowest average goals per game' do
      expect(@gtmngr.worst_offense).to eq("7")
    end
  end

  describe '#team_average_goals' do
    it 'creates a hash sorted by team id and average goals per game' do
      argument = @gtmngr.games_by_team([@gtmngr.game_teams[0], @gtmngr.game_teams[1]])
      expect(@gtmngr.team_average_goals(argument)).to be_a(Hash)
    end
  end

  describe ' #game_teams_by_team_id' do
    it 'creates a hash' do
      expect(@gtmngr.game_teams_by_team_id.class).to be(Hash)
    end
    it 'creates a hash with an array for every value' do
      expect(@gtmngr.game_teams_by_team_id.values.all?{|value| value.class == Array}).to eq(true)
    end
    it 'creates a hash with an array of GameTeam objects' do
      expect(@gtmngr.game_teams_by_team_id.values.flatten.all?{|value| value.class == GameTeam}).to eq(true)
    end
  end

  describe '#games_by_team' do
    it 'creates a hash sorted by team id and giving all game_team objects' do
      argument = [@gtmngr.game_teams[0], @gtmngr.game_teams[1]]
      expect(@gtmngr.games_by_team(argument).class).to be(Hash)
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

  describe '#highest_scoring_visitor' do
    it 'returns the team with the highest average goals as a visitor' do
      expect(@gtmngr.highest_scoring_visitor).to eq("6")
    end
  end

  describe '#lowest_scoring_visitor' do
    it 'returns the team with the lowest average goals as a visitor' do
      expect(@gtmngr.lowest_scoring_visitor).to eq("27")
    end
  end

  describe '#highest_scoring_home_team' do
    it 'returns the team with the highest average goals as a visitor' do
      expect(@gtmngr.highest_scoring_home_team).to eq("54")
    end
  end

  describe '#lowest_scoring_home_team' do
    it 'returns the team with the lowest average goals as a visitor' do
      expect(@gtmngr.lowest_scoring_home_team).to eq("7")
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

  describe ' #goals_by_team_id' do
    it 'returns a hash' do
      expect(@gtmngr.goals_by_team_id).to be_a(Hash)
    end
    it 'returns a hash with game_id keys and an integer value' do
      expect(@gtmngr.goals_by_team_id.all?{|key, value| key.class == String && value.class == Integer}).to eq(true)
    end
  end
end
