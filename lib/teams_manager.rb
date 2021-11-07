require 'csv'
require_relative './teams'
require_relative './statistics'

class TeamsManager
  include Statistics
  attr_reader :teams

  def initialize(data)
    @teams = create_teams(data)
  end

  def create_teams(teams_data)
    rows = CSV.read(teams_data, headers: true)
    rows.map do |row|
      Team.new(row)
    end
  end

  def count_of_teams
    @teams.count
  end

  def find_team_name(team_id)
    @teams.find {|team| team.team_id == team_id}.team_name
  end
end
