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
  describe ' #game_teams_by_games' do
    it 'returns all game_teams associated with multiple input games' do
      games2 = @season.games
      game_teams2 = @season.game_teams
      expect(@season.game_teams_by_games(games2)).to eq(game_teams2)
    end
  end
  describe ' #game_teams_in_season' do
    it 'returns an array of all of the game_teams that are a part of the selected season' do
      game_path = './data/games_test.csv'
      game_teams_path = './data/game_teams_test.csv'

      locations = {
        games: game_path,
        game_teams: game_teams_path
      }

      @season = Season.from_csv(locations)
      expect(@season.game_teams_in_season('20122013')).to be_a(Array)
      expect(@season.game_teams_in_season('20122013').length).to eq(4)
    end
    it "checks the helper method #" do
      expect(@season.games_in_season('20122013')).to be_an(Array)
    end
    it 'returns an array of game ids for each input game' do
      game1 = @season.game_teams[0]
      games2 = @season.games[0..2]
      expect(@season.game_ids_in_games([game1])).to eq(['2012030221'])
      expect(@season.game_ids_in_games(games2)).to eq(['2012030221','2012030222','2012030223'])
    end
  end
end
