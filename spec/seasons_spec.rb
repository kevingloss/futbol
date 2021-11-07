require 'simplecov'
SimpleCov.start

require './lib/seasons'
require 'csv'

RSpec.describe Season do
  before(:all) do
    game_path = './data/games.csv'
    game_teams_path = './data/game_teams.csv'

    locations = {
      games: game_path,
      game_teams: game_teams_path
    }

    @season = Season.from_csv(locations)
  end

  describe '#initialize' do
    it 'exists' do
      expect(@season).to be_an_instance_of(Season)
    end
  end
end
