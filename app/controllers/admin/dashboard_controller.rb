class  Admin::DashboardController < Admin::BaseController

  def index
    @logs = UserActionLog.latest.limit(10)
  end

  def search
    @videos = Video.where("title like '%#{params[:query]}%'").recent.paginate(per_page:10,page:params[:page])
  end

  def channel
    @column = Column.find_by_english(params[:english])
    @videos = Video.where(column_id: @column.id).recent.paginate(per_page:10,page:params[:page])
  end

  def users
    unless params[:query].present?
      @users = User.recent.paginate(page:params[:page])
    else
      @users = User.where("nick_name like '%#{params[:query]}%' OR email like '%#{params[:query]}%'").recent.paginate(page:params[:page])
    end
  end

  def import
  end

  def role_control
    user = User.find(params[:user_id])
    user.role = params[:role_id]
    user.save
    flash[:notice] ="『#{user.display_name}』变更为「#{user.role_name}」"
    redirect_to admin_users_path
  end

  def view_logs
    unless params[:query].present?
      @logs = UserActionLog.latest.paginate(page:params[:page])
    else
      @logs = UserActionLog.where("local_ip like '%#{params[:query]}%' OR result like '%#{params[:query]}%' OR location like '%#{params[:query]}%'").latest.paginate(page:params[:page])
    end
  end

end
