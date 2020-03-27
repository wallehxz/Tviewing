require 'csv'
class Admin::ColumnsController < Admin::BaseController

  before_action :set_column, only: [:export_videos, :edit, :update, :destroy]
  before_action :set_param, only: [:create, :update]

  def index
    @columns = Column.order('id')
  end

  def new
    @column = Column.new
  end

  def edit
  end

  def create
    @param[:cover] = Column.file_or_url(@param[:cover_file],@param[:cover])
    @param[:avatar] = Column.file_or_url(@param[:avatar_file],@param[:avatar])
    @column = Column.new(column_params)
    if @column.save
      flash[:notice] = "新栏目#{@column.name}创建成功"
      redirect_to admin_columns_path
    else
      flash[:warn] = "表单内容不完善，请检查后提交"
      render :new
    end
  end

  def update
    @param[:cover] = Column.file_or_url(@param[:cover_file],@param[:cover])
    @param[:avatar] = Column.file_or_url(@param[:avatar_file],@param[:avatar])
    if @column.update(column_params)
      flash[:notice] = "栏目#{@column.name}更新成功"
      redirect_to admin_columns_path
    else
      flash[:warn] = "表单内容不完善，请检查后提交"
      render :edit
    end
  end

  def destroy
    @column.destroy
    redirect_to admin_columns_path
  end

  def import_data
    database = params[:import][:database]
    if database == "Video"
      if params[:data_file].nil?
        flash[:warn] = "请上传视频格式的数据文件"
        redirect_to import_path
      elsif params[:column_id].nil?
        flash[:warn] = "请填写视频栏目的信息"
        redirect_to import_path
      else
        csv_text = params[:data_file].tempfile
        csv = CSV.parse(csv_text, :headers => true)
        import_video(csv,params[:column_id])
        flash[:success] = "恭喜，成功导入视频内容【#{csv.count}】条"
        redirect_to import_path
      end
    elsif database == "User"
      if params[:data_file].nil?
        flash[:warn] = "请上传会员信息格式的数据文件"
        redirect_to import_path
      else
        csv_text = params[:data_file].tempfile
        csv = CSV.parse(csv_text, :headers => true)
        import_users(csv)
        flash[:success] = "恭喜，成功导入会员信息【#{csv.count}】条"
        redirect_to import_path
      end
    elsif database == "File"
      [*'0'..'9',*'a'..'z',*'A'..'Z'].each do |word|
        Cloud.synchronize(word,1000)
      end
      flash[:success] = "恭喜，成功更新云文件【#{Cloud.all.count}】条"
      redirect_to import_path
    else
      flash[:warn] = "请选择需要更新的数据类型"
      redirect_to import_path
    end
  end

  def export_videos
    @videos = Video.where(column_id:params[:id]).order('created_at')
    send_data Video.to_csv(@videos), filename: "data-#{@column.english}.csv"
  end

  private
    def set_column
      @column = Column.find(params[:id])
    end

    def column_params
      params.require(:column).permit(:name, :english, :icon, :cover, :avatar, :summary, :vip)
    end

    def set_param
      @param = params[:column]
    end

    def import_video(data,column)
      data.each do |item|
        video = Video.new
        video.column_id = column
        video.recommend = 0
        video.video_type = item[1]
        video.title = item[2]
        video.video_url = item[3]
        video.cover = item[4]
        video.duration = item[5]
        video.save
      end
    end

    def import_user(data)
      data.each do |item|
        user = User.new
        user.email = item[1]
        user.encrypted_password = item[2]
        user.save
      end
    end
end
