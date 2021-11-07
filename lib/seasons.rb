require 'csv'
require_relative './games'
require_relative './game_teams'

class Season
  include Statistics
  attr_reader :game_teams, :games

  def initialize(games, game_teams)
    @game_teams = game_teams
    @games = games
  end

  def self.from_csv(locations)
    rows = CSV.read(locations[:games], headers: true)
    games = rows.map do |row|
      Game.new(row)
    end
    rows = CSV.read(locations[:game_teams], headers: true)
    game_teams = rows.map do |row|
      GameTeam.new(row)
    end
    Season.new(games, game_teams)
  end

  def seasons_in_game
    require "pry"; binding.pry
  end
end
