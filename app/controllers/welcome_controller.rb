class WelcomeController < ApplicationController

  force_ssl except:[:show], if: :ssl_configured?

  layout 'web', only: [:index,:column]

  def ssl_configured?
    !Rails.env.development?
  end

  def index
    @columns = Column.general.asc_id
    @videos = Video.general.recent.paginate(:page=> 1)
    UserActionLog.generate(current_user,1,request.path,request.remote_ip)
  end

  def more_index
    @videos = Video.general.recent.paginate(:page=> params[:page])
    render partial: 'shared/more_video', layout: false
  end

  def column
    @column = Column.find_by_english(params[:english])
    if @column
      @videos = Video.where(column_id:@column.id).recent.paginate(:page=> 1)
      UserActionLog.generate(current_user,1,request.path,request.remote_ip)
      if @column.id == 1 && current_user.nil?
        redirect_to sign_in_path
      elsif @column.id == 1 && current_user && current_user.nonage?
        redirect_to root_path
      end
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
    return redirect_to "http://#{request.host}#{request.fullpath}" if request.ssl?
    @video = Video.find_by_url_code(params[:url_code])
    if @video
      @video.increment(:view_count)
      @relates = @video.relates(4)
      @comments = @video.comments.latest
      UserActionLog.generate(current_user,2,request.path,request.remote_ip)
      render layout:'play'
      if @video.column_id == 1 && current_user.nil?
        redirect_to sign_in_path
      elsif @video.column_id == 1 && current_user && current_user.nonage?
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end

end
