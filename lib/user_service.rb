class UserService
  def initialize
    @ids_by_name = {
      michael: 'ccd3a910-012d-4948-8fb3-19c5651d5561'
    }
  end

  def get_user_id_by_name(name)
    return @ids_by_name[name.to_sym]
  end
end