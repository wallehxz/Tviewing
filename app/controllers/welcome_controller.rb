class WelcomeController < ApplicationController
  layout 'web', only: [:index,:column]

  def index
    @columns = Column.general.asc_id
    if params[:q].blank?
      @videos = Video.general.recent.paginate(:page=> 1)
    else
      @videos = Video.general.where("title LIKE '%#{params[:q]}%'")
    end
  end

  def more_index
    @videos = Video.general.recent.paginate(:page=> params[:page])
    render partial: 'shared/more_video', layout: false
  end

  def column
    @column = Column.find_by_english(params[:english])
    vip_colum_user(@column)
    if @column
      @videos = Video.where(column_id:@column.id).recent.paginate(:page=> 1)
      UserActionLog.generate(current_user,1,request.path,request.remote_ip)
    else
      redirect_to root_path
    end
  end

  def more_column
    @videos = Video.where(column_id:params[:column]).recent.paginate(:page=> params[:page])
    @videos = [] if params[:column] == '1' && current_user.nil?
    @videos = [] if params[:column] == '1' && current_user && current_user.nonage?
    render partial: 'shared/more_video', layout: false
  end

  def show
    @video = Video.find_by_url_code(params[:url_code])
    vip_colum_user(@video.column)
    @video.increment!(:view_count)
    @relates = @video&.relates(5)
    @comments = @video.comments.latest
    UserActionLog.generate(current_user,2,request.path,request.remote_ip)
    render layout:'play'
  end

private
  def vip_colum_user(column)
    if column.vip? && current_user.nil?
      flash[:warn] = '该内容需要登录才能浏览'
      redirect_to sign_in_path
    end
  end

end
