require 'securerandom'

class UUIDService
  def new_uuid
    return SecureRandom.uuid
  end
end