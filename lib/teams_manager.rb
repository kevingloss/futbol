require 'csv'
require_relative './teams'
require_relative './statistics'

class TeamsManager
  include Statistics
  attr_reader :teams

  def initialize(teams)
    @teams = teams
  end

  def self.from_csv(teams_data)
    rows = CSV.read(teams_data, headers: true)
    teams = rows.map do |row|
      Team.new(row)
    end
    TeamsManager.new(teams)
  end

  def count_of_teams
    @teams.count
  end

  def find_team(team_id)
    @teams.find {|team| team.team_id == team_id}
  end

  def find_team_name(team_id)
    find_team(team_id).team_name
  end

  def team_info(team_id)
    team = find_team(team_id)
    {
      "team_id" => team.team_id,
      "franchise_id" => team.franchise_id,
      "team_name" => team.team_name,
      "abbreviation" => team.abbreviation,
      "link" => team.link
    }
  end
end
