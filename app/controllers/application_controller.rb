class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  protect_from_forgery with: :null_session

  def authorize_user
    token = request.headers["Authorization"]&.split(" ")&.last
    payload = decode_token(token)
    if payload.nil?
      render json: { error: "Unauthorized" }, status: :unauthorized
    else
      @current_user = User.find(payload["user_id"])
    end
  end

  def authorize_admin
    if @current_user.nil? || !@current_user.admin?
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  private

  def decode_token(token)
    return nil if token.nil?

    begin
      decoded_token = JWT.decode(token, ENV["APP_SECRET_KEY"], true, { algorithm: "HS256" })
      decoded_token[0] # Devuelve el payload del token
    rescue JWT::DecodeError
      nil
    end
  end
end
