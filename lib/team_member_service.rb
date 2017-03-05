class TeamMemberService
  def initialize(ids_by_name)
    @ids_by_name = ids_by_name
  end

  def get_team_member_id_by_name(name)
    return @ids_by_name[name.to_sym]
  end
end