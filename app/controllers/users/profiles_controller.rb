class Users::ProfilesController < ApplicationController
  before_filter :authenticate_user!, :redirect_to_https
  layout 'user'

  def avatar
  end

  def update_avatar
    if params[:avatar]
      file = Base64.decode64(params[:avatar]['data:image/png;base64,'.length .. -1])
      current_user.avatar = Cloud.base64_file_to_yun(file)
      current_user.save
      redirect_to root_path
    else
      render :avatar
    end
  end

  def info
  end

  def update_info
    current_user.nick_name = params[:nick_name]
    current_user.phone = params[:phone]
    current_user.save
    redirect_to user_info_path
  end
end
