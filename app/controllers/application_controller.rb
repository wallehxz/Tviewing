class ApplicationController < ActionController::Base

  #protect_from_forgery with: :exception
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

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = '*'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  # def redirect_to_https
  #   if Rails.env == 'production'
  #     if action_name != 'show' && !request.ssl?
  #       redirect_to :protocol=>'https://'
  #     elsif action_name == 'show' && request.ssl?
  #       redirect_to :protocol=>'http://'
  #     end
  #   end
  # end

end
