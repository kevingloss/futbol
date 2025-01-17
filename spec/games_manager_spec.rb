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

    it 'initializes correctly from a single Game' do
      game = @gmngr.games[0]
      gmngr1 = GamesManager.new(game)
      expect(gmngr1).to be_a(GamesManager)
      expect(gmngr1.games).to be_a(Array)
      expect(gmngr1.games[0]).to be_a(Game)
    end

    it 'initializes correctly from an array of Games' do
      games = @gmngr.games[0..5]
      gmngr1 = GamesManager.new(games)
      expect(gmngr1).to be_a(GamesManager)
      expect(gmngr1.games).to be_a(Array)
      expect(gmngr1.games[0]).to be_a(Game)
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
    end
  end

  describe ' #total_goals' do
    it 'returns an array' do
      expect(@gmngr.total_goals).to be_a(Array)
    end

    it 'returns the correct array' do
      games = @gmngr.games[0..4]
      gmngr2 = GamesManager.new(games)
      expect(gmngr2.total_goals).to eq([5,5,3,5,4])
    end
  end

  describe ' #average_goals_per_game' do
    it 'returns the average # of goals per game' do
      expect(@gmngr.average_goals_per_game).to eq(4.22)
    end
  end

  describe '#total_games' do
    it 'it returns total games won by visitors' do
      actual = @gmngr.total_games
      expected = 7441
      expect(actual).to eq(expected)
    end
  end

  describe '#total_visitor wins' do
    it 'it returns total games won by visitors' do
      actual = @gmngr.total_visitor_wins
      expected = 2687
      expect(actual).to eq(expected)
    end
  end

  describe '#total_home_wins' do
    it 'it returns total games won by visitors' do
      actual = @gmngr.total_home_wins
      expected = 3237
      expect(actual).to eq(expected)
    end
  end

  describe '#total_ties' do
    it 'it returns total games that have tied' do
      actual = @gmngr.total_ties
      expected = 1517
      expect(actual).to eq(expected)
    end
  end

  describe ' #games_with_any_team_id' do
    it 'returns a an Array' do
      expect(@gmngr.games_with_any_team_id('3')).to be_a(Array)
    end

    it 'GamesManager obejct is initialized with correct games array' do
      games_array = @gmngr.games[0..6]
      new_gmngr1 = GamesManager.new(games_array)
      new_gmngr2 = new_gmngr1.games_with_any_team_id('6')
      expect(new_gmngr1.games_with_any_team_id('6')).to eq(games_array)
    end
  end

  describe ' #games_in_season' do
    it "checks the helper method #" do
      expect(@gmngr.games_in_season('20122013')).to be_an(Array)
    end
  end

  describe ' #game_ids_in_games' do
    it 'returns an array of game ids for each input game' do
      game1 = @gmngr.games[0]
      games2 = @gmngr.games[0..2]
      expect(@gmngr.game_ids_in_games([game1])).to eq(['2012030221'])
      expect(@gmngr.game_ids_in_games(games2)).to eq(['2012030221','2012030222','2012030223'])
    end
  end

  describe ' #game_ids_in_game_mngr' do
    it 'returns an array of game ids for each input game' do
      game1 = @gmngr.games[0]
      games2 = @gmngr.games[0..2]
      gmngr1 = GamesManager.new(game1)
      gmngr2 = GamesManager.new(games2)
      expect(gmngr1.game_ids_in_game_mngr).to eq(['2012030221'])
      expect(gmngr2.game_ids_in_game_mngr).to eq(['2012030221','2012030222','2012030223'])
    end
  end

  describe ' #season' do
    it 'returns a list of seasons' do
      expect(@gmngr.seasons).to be_a (Array)
    end
  end

  describe ' #game_ids_in_s' do
    it 'returns an array' do
      expect(@gmngr.game_ids_in_s('20122013')).to be_a(Array)
    end
    it 'returns an array of strings' do
      expect(@gmngr.game_ids_in_s('20122013').all?{|v|v.class == String}).to eq(true)
    end
  end
end
