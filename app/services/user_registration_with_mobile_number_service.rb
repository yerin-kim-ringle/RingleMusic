class UserRegistrationWithMobileNumberService
  attr_reader :name, :mobile_number, :email, :password, :encrypted_password, :token

  def initialize(name, mobile_number, email, password)
    @name = name
    @mobile_number = mobile_number
    @email = email
    @password = password
  end

  def register
    user = User.find_or_initialize_by name: name, mobile_number: mobile_number,
                                      email: email, password: password
    if user.save
      @token, payload = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)
      user.on_jwt_dispatch(@token, payload)
    end

    user.errors.full_messages.inspect
  end
end
