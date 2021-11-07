require 'simplecov'
SimpleCov.start

require './lib/games_manager'
require 'csv'

describe GamesManager do
  before(:all) do
    @gmngr = GamesManager.from_csv('./data/games.csv')
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
    it 'returns a values that are arrays' do
      expect(@gmngr.games_by_season.values.all?{|val| val.class == Array}).to eq(true)
    end
    it 'returns a hash with an array of games' do
      expect(@gmngr.games_by_season.values.flatten.all?{|game| game.class == Game}).to eq(true)
    end
  end

  describe ' #count_of_games_by_season' do
    it 'returns a hash with correct count of games per season' do
      expect(@gmngr.count_of_games_by_season).to be_a(Hash)
      #expect(@gmngr.count_of_games_by_season).to eq({ '20122013' => 6, '20142015' => 15 })
    end
  end
  describe ' #average_goals_per_game' do
    it 'returns the average # of goals per game' do
      expect(@gmngr.average_goals_per_game).to eq(4.22)
    end
  end
  describe '#total_games' do
    it 'it returns total games won by visitors' do
      @gmngr = GamesManager.new('./data/games_test.csv')

      actual = @gmngr.total_games
      expected = 21
      expect(actual).to eq(expected)
    end
  end
  describe '#total_visitor wins' do
    it 'it returns total games won by visitors' do
      @gmngr = GamesManager.new('./data/games_test.csv')
      actual = @gmngr.total_visitor_wins
      expected = 6
      expect(actual).to eq(expected)
    end
  end
  describe '#total_home_wins' do
    it 'it returns total games won by visitors' do
      @gmngr = GamesManager.new('./data/games_test.csv')
      actual = @gmngr.total_home_wins
      expected = 9
      expect(actual).to eq(expected)
    end
  end
  describe '#total_ties' do
    it 'it returns total games that have tied' do
      @gmngr = GamesManager.new('./data/games_test.csv')
      actual = @gmngr.total_ties
      expected = 6
      expect(actual).to eq(expected)
    end
  end

  it "checks the helper method #" do
    expect(@gmngr.games_in_season('20122013')).to be_an(Array)
  end

  it 'returns an array of game ids for each input game' do
    game1 = @gmngr.games[0]
    games2 = @gmngr.games[0..2]
    expect(@gmngr.game_ids_in_games([game1])).to eq(['2012030221'])
    expect(@gmngr.game_ids_in_games(games2)).to eq(['2012030221','2012030222','2012030223'])
  end
end
