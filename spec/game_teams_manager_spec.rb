require 'simplecov'
SimpleCov.start

require './lib/game_teams_manager'
require 'csv'

describe GameTeamsManager do
  before(:each) do
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

  describe '#team_average_goals' do
    it 'creates a hash sorted by team id and average goals per game' do
      expect(@gtmngr.team_average_goals).to be_a(Hash)
    end
  end

  describe '#all_games_by_team' do
    it 'creates a hash sorted by team id and giving all game_team objects' do
      expect(@gtmngr.all_games_by_team.class).to be(Hash)
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


end
