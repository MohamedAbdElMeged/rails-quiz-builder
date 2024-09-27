# frozen_string_literal: true

class ApplicationController < ActionController::API
  def authorize_request
    return head(:unauthorized) unless auth_header

    decoded_hash = JwtHelper.decode(auth_token)
    return head(:unauthorized) unless decoded_hash

    @current_user = User.find_by(email: decoded_hash.dig('data', 'email'))
    @current_user
  end

  def auth_header
    request.headers['Authorization']
  end

  def auth_token
    auth_header&.split&.last
  end
end
