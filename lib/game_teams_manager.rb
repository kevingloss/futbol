require 'csv'
require_relative './game_teams'

class GameTeamsManager
  attr_reader :game_teams

  def initialize(data)
    @game_teams = create_game_teams(data)
  end

  def create_game_teams(game_teams_data)
    rows = CSV.read(game_teams_data, headers: true)
    rows.map do |row|
      GameTeam.new(row)
    end
  end
end
