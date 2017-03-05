require 'spec_helper'

describe('UserService') do
  it('should get user id by name') do
    user_service = UserService.new

    expect(user_service.get_user_id_by_name('michael')).to eq 'ccd3a910-012d-4948-8fb3-19c5651d5561'
  end
end