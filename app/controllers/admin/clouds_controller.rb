class Admin::CloudsController < Admin::BaseController

  skip_filter :verify_authenticity_token, only:[:create, :update]
  before_filter :set_file, only:[:edit, :update, :destroy]

  def index
    return @files = Cloud.where("clouds.key LIKE '%#{params[:prefix]}%' OR clouds.mine_type LIKE '%#{params[:prefix]}%'").recent.paginate(page:params[:page]) if params[:prefix].present?
    @files = Cloud.recent.paginate(page:params[:page])
  end

  def new
  end

  def create
    if params[:file].present?
      file_name = Cloud.rename_ext_file(params[:file])
      file_path = params[:file].path
      Cloud.upload_yun(file_name,file_path)
      new_file = Cloud.file_to_info(file_name)
      Cloud.restore_to_sql(file_name)
      flash[:success] = "文件【#{file_name}】上传成功！"
      redirect_to admin_files_path
    else
      flash[:warn] = '请选择上传文件！'
      render :new
    end
  end

  def edit
  end

  def update
    if params[:new].split('.')[1]
      full_name = params[:new]
    else
      ext = @file.mine_type.split('/')[1]
      full_name = "#{params[:new]}.#{ext}"
    end
    if Cloud.rename_yun_file_name(@file.key,full_name)
      @file.update_attributes(key:full_name)
      flash[:success] = '文件重命名成功'
      redirect_to admin_files_path
    else
      flash[:warn] = '文件名已经存在，请编辑新的名称'
      redirect_to edit_file_path(@file.id)
    end

  end

  def destroy
    if Cloud.delete_yun_file(@file.key)
      @file.delete
      flash[:success] = "【#{@file.key}】文件删除成功"
      redirect_to admin_files_path
    else
      flash[:error] = "【#{@file.key}】云服务器异常或文件已经不存在"
      redirect_to admin_files_path
   end
  end

 private
  def set_file
    @file = Cloud.find(params[:id])
  end

end
