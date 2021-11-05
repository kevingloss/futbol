require 'simplecov'
SimpleCov.start

require './lib/teams_manager'
require 'csv'

describe TeamsManager do
  before(:each) do
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
end
