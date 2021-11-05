require 'csv'
require_relative './teams'

class TeamsManager
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
end
