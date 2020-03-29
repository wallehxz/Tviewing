class Users::SessionsController < Devise::SessionsController
  layout 'user'

  def new
  end

  # POST /resource/sign_in
  def create
    user = User.find_by_email(params[:user][:email])
    if params[:user][:email].blank? || params[:user][:password].blank?
      flash[:email] = "邮箱或密码为空"
      render :new
    elsif !user
      new = User.create(new_params)
      sign_in(new)
      UserActionLog.generate(current_user,7,env['REQUEST_PATH'],current_user.current_sign_in_ip)
      redirect_to root_path
    elsif user && !user.valid_password?(params[:user][:password])
      flash[:password] = "密码错误"
      flash[:set_email] = params[:user][:email]
      render :new
    else
      sign_in(user)
      user.set_location
      UserActionLog.generate(current_user,5,env['REQUEST_PATH'],current_user.current_sign_in_ip)
      flash[:notice] = (t 'devise.sessions.signed_in')
      redirect_to root_path
    end
  end

  private

    def new_params
      params.require(:user).permit(:email, :password)
    end

end
