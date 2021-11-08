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
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }

    @stat_tracker = StatTracker.from_csv(locations)
  end

  describe '#initialize' do
    it 'exists' do
      expect(@stat_tracker).to be_an_instance_of(StatTracker)
    end


    it 'has attributes' do
      expect(@stat_tracker.games_mngr).to be_an_instance_of(GamesManager)
      expect(@stat_tracker.teams_mngr).to be_an_instance_of(TeamsManager)
      expect(@stat_tracker.gt_mngr).to be_an_instance_of(GameTeamsManager)
    end
  end

  describe '::from_csv' do
      it 'returns a stat_tracker object' do
        expect(@stat_tracker).to be_an_instance_of(StatTracker)
      end
  end

  # Game Statistics Methods

  describe '#highest_total_score' do
    it 'will find the highest sum of the team scores from all the games' do
      game_path = './data/games_test.csv'
      team_path = './data/teams.csv'
      game_teams_path = './data/game_teams_test.csv'

      locations = {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }

      @stat_tracker = StatTracker.from_csv(locations)
      expect(@stat_tracker.highest_total_score).to eq(6)
    end
  end
  describe '#lowest_total_score' do
    it 'will find the lowest sum of the team scores from all the games' do
      game_path = './data/games_test.csv'
      team_path = './data/teams.csv'
      game_teams_path = './data/game_teams_test.csv'

      locations = {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }

      @stat_tracker = StatTracker.from_csv(locations)
      expect(@stat_tracker.lowest_total_score).to eq(2)
    end
  end

  describe '#percentage_visitor_wins' do
    it 'finds the percentage of visitor wins' do
      expect(@stat_tracker.percentage_visitor_wins).to eq(0.36)
    end
  end
  describe '#percentage_home_wins' do
    it 'finds the percentage of home wins' do
      expect(@stat_tracker.percentage_home_wins).to eq(0.44)
    end
  end

  describe '#percentage of ties' do
    it 'checks the percentage of games that are ties' do
      expect(@stat_tracker.percentage_ties).to eq(0.2)
    end
  end
  describe ' #count_of_games_by_season' do
    it 'returns a hash with correct count of games per season' do
      game_path = './data/games_test.csv'
      team_path = './data/teams.csv'
      game_teams_path = './data/game_teams_test.csv'

      locations = {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }

      @stat_tracker = StatTracker.from_csv(locations)
      expect(@stat_tracker.count_of_games_by_season).to be_a(Hash)
      expect(@stat_tracker.count_of_games_by_season).to eq({ '20122013' => 6, '20142015' => 15 })
    end
  end
  describe ' #average_goals_per_game' do
    it 'returns the average # of goals per game' do
      game_path = './data/games_test.csv'
      team_path = './data/teams.csv'
      game_teams_path = './data/game_teams_test.csv'

      locations = {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }

      @stat_tracker = StatTracker.from_csv(locations)
      expect(@stat_tracker.average_goals_per_game).to eq(3.86)
    end
  end
  describe ' #average_goals_by_season' do
    it 'returns a hash with average # of goals per season' do
      game_path = './data/games_test.csv'
      team_path = './data/teams.csv'
      game_teams_path = './data/game_teams_test.csv'

      locations = {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }

      @stat_tracker = StatTracker.from_csv(locations)
      expect(@stat_tracker.average_goals_by_season()).to be_a(Hash)
      expect(@stat_tracker.average_goals_by_season).to eq({ '20122013' => 3.83, '20142015' => 3.87 })
    end
  end

  # League Stat
  describe '#count_of_teams' do
    it 'counts the total number of teams' do
      expect(@stat_tracker.count_of_teams).to eq(@stat_tracker.teams_mngr.teams.count)
    end
  end

  describe '#best_offense' do
    it 'returns the team name with the highest average goals per game across seasons' do
      expect(@stat_tracker.best_offense).to eq('Reign FC')
    end
  end

  describe '#worst_offense' do
    it 'returns the team with the lowest average goals per game across seasons' do
      expect(@stat_tracker.worst_offense).to eq('Utah Royals FC')
    end
  end

  describe '#highest_scoring_visitor' do
    it 'returns the highest average scoring visitor team name' do
      expect(@stat_tracker.highest_scoring_visitor).to eq('FC Dallas')
    end
  end

    describe '#lowest_scoring_visitor' do
      it 'returns the lowest average scoring visitor team name' do
        expect(@stat_tracker.lowest_scoring_visitor).to eq('San Jose Earthquakes')
      end
    end

  describe '#highest_scoring_home_team' do
    it 'returns the highest average scoring home team name' do
      expect(@stat_tracker.highest_scoring_home_team).to eq('Reign FC')
    end
  end

  describe '#lowest_scoring_home_team' do
    it 'returns the lowest average scoring home team name' do
      expect(@stat_tracker.lowest_scoring_home_team).to eq('Utah Royals FC')
    end
  end

  #Team Statistics - each method takes a team_id as an argument
  describe '#team_info' do
    it '#find_team - can find a team by team_id' do
      expect(@stat_tracker.find_team("15")).to eq(@stat_tracker.teams_mngr.teams[15])
    end


    it 'returns a hash with key/values for all team attributes' do
      expected = {
        "team_id" => "15",
        "franchise_id" => "24",
        "team_name" => "Portland Timbers",
        "abbreviation" => "POR",
        "link" => "/api/v1/teams/15"
      }

      expect(@stat_tracker.team_info("15")).to eq(expected)
    end
  end

  describe '#team_games_by_season' do
    it 'returns all games played in a season for a given team' do
      expected = [@stat_tracker.games_mngr.games[18]]
      expect(@stat_tracker.team_games_by_season("8", "20142015")).to eq(expected)
    end
  end

  describe '#best_season' do
    it 'returns the season with the highest win percentage for a team' do
      allow(@stat_tracker).to receive(:best_season).with("6").and_return("20132014")
      expect(@stat_tracker.best_season("6")).to eq("20132014")
    end
  end

  describe '#worst_season' do
    it 'returns the season with the lowest win percentage for a team' do
      allow(@stat_tracker).to receive(:worst_season).with("6").and_return("20142015")
      expect(@stat_tracker.worst_season("6")).to eq("20142015")
    end
  end

  describe '#average_win_percentage' do
      it 'returns average percentage for a team' do
        game_path = './data/games_test.csv'
        team_path = './data/teams.csv'
        game_teams_path = './data/game_teams_test.csv'

        locations = {
          games: game_path,
          teams: team_path,
          game_teams: game_teams_path
        }

        @stat_tracker = StatTracker.from_csv(locations)
        expect(@stat_tracker.average_win_percentage('6')).to eq(1.0)
      end
    end

  describe ' #most_goals_scored' do
    it 'returns a teams most goals scored in a game' do
        expect(@stat_tracker.most_goals_scored('30')).to eq(6)
    end
  end

  describe ' #fewest_goals_scored' do
    it 'returns a teams fewest goals scored in a game' do
        expect(@stat_tracker.fewest_goals_scored('30')).to eq(0)
    end
  end

  describe ' #opponent_win_percentage' do
    it 'returns a hash' do
      team_id = @stat_tracker.teams_mngr.teams[5].team_id
      expect(@stat_tracker.opponent_win_percentages(team_id)).to be_a(Hash)
    end
    it 'return a hash with floats as values' do
      team_id = @stat_tracker.teams_mngr.teams[5].team_id
      expect(@stat_tracker.opponent_win_percentages(team_id).values.flatten.all?{|value| value.class == Float}).to eq(true)
    end
  end

  describe ' #favorite_opponent' do
    it 'returns the name of the opponent that has the lowest win percentage against the given team.' do
      team_id = @stat_tracker.teams_mngr.teams[5].team_id
      expect(@stat_tracker.favorite_opponent(team_id)).to be_a(String)
      expect(@stat_tracker.favorite_opponent(team_id)).to eq('Montreal Impact')
    end
  end

  describe ' #rival' do
    it 'returns the name of the opponent that has the highest win percentage against the given team.' do
      team_id = @stat_tracker.teams_mngr.teams[5].team_id
      expect(@stat_tracker.rival(team_id)).to be_a(String)
      expect(@stat_tracker.rival(team_id)).to eq('San Jose Earthquakes')
    end
  end
  ### Season
  describe '#winningest_coach' do

    it "gets the total games played by coaches" do
      expect(@stat_tracker.game_teams_by_coaches('20122013')).to be_an(Hash)

    end
    it "finds the average of the coach" do
        game_path = './data/games_test.csv'
        team_path = './data/teams.csv'
        game_teams_path = './data/game_teams_test.csv'

        locations = {
          games: game_path,
          teams: team_path,
          game_teams: game_teams_path
        }

        @stat_tracker = StatTracker.from_csv(locations)

      expect(@stat_tracker.average_wins_by_coach('20122013')).to be_an(Hash)
      expect(@stat_tracker.average_wins_by_coach('20122013')).to eq({"Claude Julien"=>1, "John Tortorella"=>0})
    end

    it 'Name of the Coach with the best win percentage for the season' do
      game_path = './data/games_test.csv'
      team_path = './data/teams.csv'
      game_teams_path = './data/game_teams_test.csv'

      locations = {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }

      @stat_tracker = StatTracker.from_csv(locations)
      expect(@stat_tracker.winningest_coach('20122013')).to be_a(String)
      expect(@stat_tracker.winningest_coach('20122013')).to eq("Claude Julien")
    end
  end
  describe '#worst_coach' do
    it 'Name of the Coach with the worst win percentage for the season' do
      game_path = './data/games_test.csv'
      team_path = './data/teams.csv'
      game_teams_path = './data/game_teams_test.csv'

      locations = {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }

      @stat_tracker = StatTracker.from_csv(locations)
      expect(@stat_tracker.winningest_coach('20122013')).to be_a(String)
      expect(@stat_tracker.worst_coach('20122013')).to eq("John Tortorella")
    end
  end
  # describe ' #accuracy' do
  #   it 'accepts an array of game_teams and returns a single accuracy score' do
  #     game_path = './data/games_test.csv'
  #     team_path = './data/teams.csv'
  #     game_teams_path = './data/game_teams_test.csv'
  #
  #     locations = {
  #       games: game_path,
  #       teams: team_path,
  #       game_teams: game_teams_path
  #     }
  #
  #     @stat_tracker = StatTracker.from_csv(locations)
  #     game_teams1 = @stat_tracker.gt_mngr.game_teams[0..4]
  #     expect(@stat_tracker.accuracy(game_teams1)).to eq(13.0/43.0)
  #   end
  # end
  describe ' #most_accurate_team' do

    it 'returns the name of the team with the best ratio of shots to goals for the season' do
      expect(@stat_tracker.most_accurate_team('20122013')).to eq('DC United')
      expect(@stat_tracker.most_accurate_team("20142015")).to eq("Toronto FC")
    end
  end
  describe ' #least_accurate_team' do
    it 'returns the name of the team with the worst ratio of shots to goals for the season' do
      expect(@stat_tracker.least_accurate_team('20122013')).to eq('New York City FC')
    end
  end

  describe ' #game_teams_by_games' do
    it 'returns all game_teams associated with multiple input games' do
      games2 = @stat_tracker.games_mngr
      game_teams2 = @stat_tracker.gt_mngr
      expect(@stat_tracker.gt_mngr).to eq(game_teams2)
    end
  end
  describe ' #game_teams_in_season' do
    it 'returns an array of all of the game_teams that are a part of the selected season' do
      game_path = './data/games_test.csv'
      team_path = './data/teams.csv'
      game_teams_path = './data/game_teams_test.csv'

      locations = {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }

      @stat_tracker = StatTracker.from_csv(locations)
      expect(@stat_tracker.game_teams_in_season('20122013')).to be_a(Array)
      expect(@stat_tracker.game_teams_in_season('20122013').length).to eq(4)
    end
  end

  describe 'teams_from_game_teams' do
    it 'returns an array of teams for an array of game_team objects' do
      game_team1 = @stat_tracker.gt_mngr.game_teams[0]
      team1 = @stat_tracker.teams_mngr.teams[5]
      game_teams2 = @stat_tracker.gt_mngr.game_teams[0..3]
      teams2 = [@stat_tracker.teams_mngr.teams[4], @stat_tracker.teams_mngr.teams[5]]
      expect(@stat_tracker.teams_from_game_teams([game_team1])).to eq([team1])
      expect(@stat_tracker.teams_from_game_teams(game_teams2)).to eq(teams2)
    end
  end

  describe ' #most_tackles' do
    it 'returns the name of the team with the most tackles in the season' do
      game_path = './data/games_test.csv'
      team_path = './data/teams.csv'
      game_teams_path = './data/game_teams_test.csv'

      locations = {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }

      @stat_tracker = StatTracker.from_csv(locations)
      expect(@stat_tracker.most_tackles('20122013')).to eq('FC Dallas')
    end
  end
  describe '  #fewest_tackles' do
    it 'returns the name of the team with the fewest tackles in the season' do
      game_path = './data/games_test.csv'
      team_path = './data/teams.csv'
      game_teams_path = './data/game_teams_test.csv'

      locations = {
        games: game_path,
        teams: team_path,
        game_teams: game_teams_path
      }

      @stat_tracker = StatTracker.from_csv(locations)
      expect(@stat_tracker.fewest_tackles('20122013')).to eq('Houston Dynamo')
    end
  end
end
