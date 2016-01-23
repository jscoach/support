class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def redirect_to_back(*options)
    redirect_to :back, *options
  rescue ActionController::RedirectBackError
    redirect_to root_path, *options
  end
end
