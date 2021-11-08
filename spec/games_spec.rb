require 'simplecov'
SimpleCov.start

require './lib/games.rb'
require 'csv'

RSpec.describe Game do

  before :each do
    @rows = CSV.read('./data/games.csv', headers: true)
    @row = @rows[0]

    @game1 = Game.new(@row)
  end

  describe 'initialize' do
    it "exists" do
      expect(@game1).to be_a(Game)
    end

    it "checks that all the attributes" do
      expect(@game1.game_id).to eq('2012030221')
      expect(@game1.season).to eq('20122013')
      expect(@game1.type).to eq('Postseason')
      expect(@game1.date_time).to eq('5/16/13')
      expect(@game1.away_team_id).to eq('3')
      expect(@game1.home_team_id).to eq('6')
      expect(@game1.away_goals).to eq(2)
      expect(@game1.home_goals).to eq(3)
      expect(@game1.venue).to eq('Toyota Stadium')
      expect(@game1.venue_link).to eq('/api/v1/venues/null')
    end
  end

  describe ' #total_goals' do
    it 'returns total of home and away goals' do
      expect(@game1.total_goals).to eq(5)
    end

  end
end
