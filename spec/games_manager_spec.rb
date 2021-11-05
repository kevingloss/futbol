require 'simplecov'
SimpleCov.start

require './lib/games_manager'
require 'csv'

describe GamesManager do
  before(:each) do
    @gmngr = GamesManager.new('./data/games.csv')
  end

  describe '#initialize' do
    it 'exists' do
      expect(@gmngr).to be_an_instance_of(GamesManager)
    end

    it 'has default values' do
      expect(@gmngr.games[0]).to be_an_instance_of(Game)
      expect(@gmngr.games.count).to eq(7441)
    end
  end

  describe '#highest_total_score' do
    it 'will find the highest sum of the team scores from all the games' do
      expect(@gmngr.highest_total_score).to eq(11)
    end
  end
  describe '#lowest_total_score' do
    it 'will find the lowest sum of the team scores from all the games' do
      expect(@gmngr.lowest_total_score).to eq(0)
    end
  end
end
