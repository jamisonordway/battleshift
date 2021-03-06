class ApplicationController < ActionController::Base
  helper_method :current_user
  protect_from_forgery with: :exception

  def current_user
    if session[:user_id]
      id = session[:user_id]
      if User.exists?(id)
        @current_user ||= User.find(id)
      end
    end
  end

end
