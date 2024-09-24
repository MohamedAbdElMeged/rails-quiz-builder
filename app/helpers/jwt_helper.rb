# frozen_string_literal: true

module JwtHelper
  JWT_SECRET_KEY = ENV.fetch('JWT_SECRET', nil)
  def self.encode(_data, expires_in: 10.minutes)
    exp = Time.now.to_i + expires_in
    payload = { data: 'data', exp: }
    JWT.encode(payload, JWT_SECRET_KEY, 'HS256')
  end

  def self.decode(token)
    JWT.decode(token, ENV.fetch('JWT_SECRET', nil), true, { algorithm: 'HS256' }).first
  rescue JWT::ExpiredSignature
    # Handle expired token, e.g. logout user or deny access
    # render json: "errror"
  end
end
