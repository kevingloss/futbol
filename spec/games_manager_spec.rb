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

  describe ' #games_with_home_team_id' do
    it 'returns a new GamesManager object' do
      expect(@gmngr.games_with_home_team_id('3')).to be_a(GamesManager)
    end
    it 'GamesManager obejct is initialized with correct games array' do
      games_array = @gmngr.games[0..6]
      new_gmngr1 = GamesManager.new(games_array)
      new_gmngr2 = new_gmngr1.games_with_home_team_id('6')
      team_6_games = [new_gmngr1.games[0], new_gmngr1.games[1], new_gmngr1.games[4]]
      expect(new_gmngr1.games_with_home_team_id('6').games).to eq(team_6_games)
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

  describe ' #game_ids_in_game_' do
    it 'returns an array of game ids for each input game' do
      game1 = @gmngr.games[0]
      games2 = @gmngr.games[0..2]
      gmngr1 = GamesManager.new(game1)
      gmngr2 = GamesManager.new(games2)
      expect(gmngr1.game_ids_in_game_mngr).to eq(['2012030221'])
      expect(gmngr2.game_ids_in_game_mngr).to eq(['2012030221','2012030222','2012030223'])
    end
  end
end
