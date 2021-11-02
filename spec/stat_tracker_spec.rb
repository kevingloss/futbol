require 'simplecov'
SimpleCov.start

require './lib/stat_tracker'

RSpec.describe StatTracker do

  # before(:all) do
  #   game_path = './data/games.csv'
  #   team_path = './data/teams.csv'
  #   game_teams_path = './data/game_teams.csv'
  #
  #   locations = {
  #     games: game_path,
  #     teams: team_path,
  #     game_teams: game_teams_path
  #   }
  #
  #   @stat_tracker = StatTracker.from_csv(locations)
  # end

  before(:all) do
    game_path = './data/games_test.csv'
    team_path = './data/teams_test.csv'
    game_teams_path = './data/game_teams_test.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }

    @stat_tracker = StatTracker.from_csv(locations)
  end

  describe '#initialize' do
    it 'exists' do
      stat_tracker2 = StatTracker.new()
      expect(stat_tracker2).to be_an_instance_of(StatTracker)
    end

    it 'has attributes' do
      stat_tracker2 = StatTracker.new()
      expect(stat_tracker2.games).to be_a(Array)
      expect(stat_tracker2.teams).to be_a(Array)
      expect(stat_tracker2.game_teams).to be_a(Array)
      expect(stat_tracker2.games).to eq([])
      expect(stat_tracker2.teams).to eq([])
      expect(stat_tracker2.game_teams).to eq([])
    end
  end

  describe '::from_csv' do
    describe 'returns a StatTracker object' do
      it 'exists' do
        expect(@stat_tracker).to be_an_instance_of(StatTracker)
      end

      it 'has correct attributes and classes' do
        expect(@stat_tracker.games).to be_a(Array)
        expect(@stat_tracker.teams).to be_a(Array)
        expect(@stat_tracker.game_teams).to be_a(Array)
        expect(@stat_tracker.games[0]).to be_a(Games)
        expect(@stat_tracker.teams[0]).to be_a(Teams)
        expect(@stat_tracker.game_teams[0]).to be_a(GameTeams)
      end
    end
  end

  #Game Statistics Methods

  describe '#highest_total_score' do
    it 'will find the highest sum of the team scores from all the games' do
      expect(@stat_tracker.highest_total_score).to eq(6)
    end
  end
  describe '#lowest_total_score' do
    it 'will find the lowest sum of the team scores from all the games' do
      expect(@stat_tracker.lowest_total_score).to eq(2)
    end
  end


  describe  "percentage wins" do
    it "finds the percentage of visitor wins" do
      expect(@stat_tracker.percentage_visitor_wins).to eq(0.29)
    end
    it "finds the percentage of home wins" do
      expect(@stat_tracker.percentage_home_wins).to eq(0.43)
    end
  end

  describe "#percentage of ties" do
    it "checks the percentage of games that are ties" do
      expect(@stat_tracker.percentage_ties).to eq(0.29)
    end
  end
  describe ' #count_of_games_by_season' do
    it 'returns a hash with correct count of games per season' do
      expect(@stat_tracker.count_of_games_by_season).to be_a(Hash)
      expect(@stat_tracker.count_of_games_by_season).to eq({"20122013" => 6, "20142015" => 15})
    end
  end
  describe ' #avgerage_goals_per_game' do
    it 'returns the avgerage # of goals per game' do
      expect(@stat_tracker.avgerage_goals_per_game).to eq(3.86)
    end
  end
  describe ' #avgerage_goals_per_season' do
    it 'returns a hash with avgerage # of goals per season' do
      expect(@stat_tracker.avgerage_goals_per_season).to eq({"20122013" => 3.83, "20142015" => 3.87})
    end
  end

  #League Stat
  describe '#highest_scoring_visitor' do
    xit 'returns highest score from vistor team' do

    end
  end

  describe '#worst_offense' do
    xit '' do

    end
  end

  describe '#highest_scoring_home_team' do
    xit '' do

    end
  end

  describe '#lowest_scoring_visitor' do
    xit '' do

    end
  end

  describe '#lowest_scoring_home_team' do
    xit '' do

    end
  end

  describe '#team_info' do
    xit '' do

    end
  end

  describe '#best_season' do
    xit '' do

    end
  end

  describe '#worst_season' do
    xit '' do

    end
  end

  describe '#average_win_percentage' do
    xit '' do

    end
  end

  describe '#most_goals_scored' do
    xit '' do

    end
  end

  describe '#rival' do
    xit '' do

    end
  end

  describe '#rival' do
    xit '' do

    end
  end
  ### Season
  describe '#winningest_coach' do
    xit '' do

    end
  end
  describe '#worst_coach' do
    xit '' do

    end
  end
  describe '#most_accurate_team' do
    xit '' do

    end
  end
  describe '#least_accurate_team' do
    xit '' do

    end
  end
  describe '#most_tackles' do
    xit '' do

    end
  end
  describe '#fewest_tackles' do
    xit '' do

    end
  end


end
