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
end
