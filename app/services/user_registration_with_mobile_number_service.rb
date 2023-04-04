class UserRegistrationWithMobileNumberService
  attr_reader :mobile_number, :email, :password, :encrypted_password, :token

  def initialize(mobile_number, email, password, encrypted_password)
    @mobile_number = mobile_number
    @email = email
    @password = password
    @encrypted_password = encrypted_password
  end

  def register
    user = User.find_or_initialize_by mobile_number: mobile_number, email: email, password: password, encrypted_password: encrypted_password
    if user.save
      @token, payload = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)
      user.on_jwt_dispatch(@token, payload)
      # TODO: UserRegistrationJob.perform_later(user.id)
    end

    user.errors.full_messages.inspect
  end
end