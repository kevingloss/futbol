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

  describe ' #games_by_season' do
    it 'returns a hash' do
      expect(@gmngr.games_by_season).to be_a(Hash)
    end
    it 'returns a hash with an array of games' do
      expect(@gmngr.games_by_season.values.flatten.all?{|game| game.class == Game}).to eq(true)
    end
  end

  describe ' #count_of_games_by_season' do
    it 'returns a hash with correct count of games per season' do
      expect(@gmngr.count_of_games_by_season).to be_a(Hash)
      expect(@gmngr.count_of_games_by_season).to eq({ '20122013' => 6, '20142015' => 15 })
    end
  end
  describe ' #average_goals_per_game' do
    it 'returns the average # of goals per game' do
      expect(@gmngr.average_goals_per_game).to eq(3.86)
    end
  end
end
