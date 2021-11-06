require 'simplecov'
SimpleCov.start

require './lib/teams_manager'
require 'csv'

describe TeamsManager do
  before(:all) do
    @tmngr = TeamsManager.new('./data/teams.csv')
  end

  describe '#initialize' do
    it 'exists' do
      expect(@tmngr).to be_an_instance_of(TeamsManager)
    end

    it 'has default values' do
      expect(@tmngr.teams[0]).to be_an_instance_of(Team)
      expect(@tmngr.teams.count).to eq(32)
    end
  end

  describe '#count_of_teams' do
    it 'returns the number of teams' do
      expect(@tmngr.count_of_teams).to eq(32)
    end
  end

  describe '#find_team_name' do
    it 'returns a team name by team_id number' do
      expect(@tmngr.find_team_name("54")).to eq("Reign FC")
    end
  end
end
