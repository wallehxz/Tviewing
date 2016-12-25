class ApplicationController < ActionController::Base

  #protect_from_forgery with: :exception
  before_filter :redirect_to_https
  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      respond_to do |format|
        format.html { redirect_to root_path }
      end
    else
      respond_to do |format|
        format.html { redirect_to sign_in_path }
      end
    end
  end

  def redirect_to_https
    if Rails.env == 'production'
      if action_name != 'show' && !request.ssl?
        redirect_to "https://www.koogle.cc/#{request.fullpath}"
      elsif action_name == 'show' && request.ssl?
        redirect_to "http://www.koogle.cc/#{request.fullpath}"
      end
    end
  end

end
