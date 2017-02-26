require 'securerandom'

class UUIDService
  def uuid
    return SecureRandom.uuid
  end
end