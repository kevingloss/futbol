require 'simplecov'
SimpleCov.start

require './lib/teams_manager'
require 'csv'

describe TeamsManager do
  before(:all) do
    @tmngr = TeamsManager.from_csv('./data/teams.csv')
  end

  describe '#initialize' do
    it 'exists' do
      expect(@tmngr).to be_an_instance_of(TeamsManager)
    end

    it 'has default values' do
      expect(@tmngr.teams[0]).to be_an_instance_of(Team)
      expect(@tmngr.teams.count).to eq(32)
    end

    it 'initializes correctly from a single Team' do
      team = @tmngr.teams[0]
      tmngr1 = TeamsManager.new(team)
      expect(tmngr1).to be_a(TeamsManager)
      expect(tmngr1.teams).to be_a(Array)
      expect(tmngr1.teams[0]).to be_a(Team)
    end
    it 'initializes correctly from an array of Teams' do
      teams = @tmngr.teams[0..5]
      tmngr1 = TeamsManager.new(teams)
      expect(tmngr1).to be_a(TeamsManager)
      expect(tmngr1.teams).to be_a(Array)
      expect(tmngr1.teams[0]).to be_a(Team)
    end
  end

  describe '#count_of_teams' do
    it 'returns the number of teams' do
      expect(@tmngr.count_of_teams).to eq(32)
    end
  end

  describe '#find_team_name' do
    it 'returns a team name by team_id number' do
      expect(@tmngr.find_team("4")).to eq(@tmngr.teams[1])
    end
  end

  describe '#find_team_name' do
    it 'returns a team name by team_id number' do
      expect(@tmngr.find_team_name("54")).to eq("Reign FC")
    end
  end

  describe '#team_info' do
    it 'returns a hash with key/values for all team attributes' do
      expected = {
        "team_id" => "15",
        "franchise_id" => "24",
        "team_name" => "Portland Timbers",
        "abbreviation" => "POR",
        "link" => "/api/v1/teams/15"
      }

      expect(@tmngr.team_info("15")).to eq(expected)
    end
  end
end
