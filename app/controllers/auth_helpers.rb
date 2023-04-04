module AuthHelpers
  def current_user
    decoded_token = JWT.decode token, Devise.secret_key, true, { algorithm: "HS256" }
    self.verify(decoded_token)
  end

  def verify(decoded_token)
    payload={jti: decoded_token[0]["jti"], aud: decoded_token[0]["aud"]}
    user= User.find_by id: decoded_token[0]["sub"]
    User.jwt_revoked? payload, user
    user
  end

  def token
    auth = headers['Authorization'].to_s
    auth.split.last
  end
end