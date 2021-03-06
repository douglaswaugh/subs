require 'spec_helper'

describe('TeamMemberService') do
  it('should get user id by name') do
    ids_by_name = {
      michael: 'ccd3a910-012d-4948-8fb3-19c5651d5561'
    }

    team_member_service = TeamMemberService.new(ids_by_name)

    expect(team_member_service.get_team_member_id_by_name('michael')).to eq 'ccd3a910-012d-4948-8fb3-19c5651d5561'
  end
end