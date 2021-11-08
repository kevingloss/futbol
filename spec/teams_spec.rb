require 'simplecov'
SimpleCov.start

require './lib/teams'
require 'csv'

describe Team do
  before(:each) do
    @rows = CSV.read('./data/teams.csv', headers: true)
    @row = @rows[0]

    @team = Team.new(@row)
  end
  describe 'initialize' do
    it 'exists' do
      expect(@team).to be_a(Team)
    end
    it 'has attributes' do
      expect(@team.team_id).to eq('1')
      expect(@team.franchise_id).to eq('23')
      expect(@team.team_name).to eq('Atlanta United')
      expect(@team.abbreviation).to eq('ATL')
      expect(@team.stadium).to eq('Mercedes-Benz Stadium')
      expect(@team.link).to eq('/api/v1/teams/1')
    end
  end
end
