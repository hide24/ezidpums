class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  USERS = {
   "root" => "password"
 }
 
  before_action :authenticate
 
  private
    def authenticate
      authenticate_or_request_with_http_digest do |username|
        USERS[username]
      end
    end
end
