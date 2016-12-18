# t.string   "key",       limit: 255
# t.string   "size",      limit: 255
# t.string   "mine_type", limit: 255
# t.string   "md5_value", limit: 255
# t.datetime "upload_at"

require 'qiniu'
class Cloud < ActiveRecord::Base

  scope :recent,->{ order('upload_at desc') }
  self.per_page = 10

  #获取七牛服务文件列表
  # Cattle.files_list
  def self.files_list(prefix= '',marker = '')
    bucket = 'meteor' #指定空间
    limit = 10
    list_policy = Qiniu::Storage::ListPolicy.new(bucket,limit,prefix)
    list_policy.marker = marker  #加上对象
    code,result,headers = Qiniu::Storage.list(list_policy)
    return result['marker'],result['items']
  end

  #云存储文件统计
  # Cattle.file_sum
  def self.file_sum()
    bucket = 'meteor' #指定空间
    limit = 10000
    prefix= ''
    list_policy = Qiniu::Storage::ListPolicy.new(bucket,limit,prefix)
    code,result,headers = Qiniu::Storage.list(list_policy)
    return result['items'].size
  end

  #将文件缓存到本地磁盘，生成新的名称和地址
  def self.local_cache_file(file)
    dir_path = "#{Rails.root}/public/uploads" #软链文件 授权 chmod -R 777 uploads
    FileUtils.mkdir(dir_path) unless File.exist?(dir_path) #如果目录不存在,创建目录
    file_name = rename_ext_file(file)
    file_path = "#{dir_path}/#{file_name}"
    File.open(file_path,'wb+') do |item|
      item.write(file.read)
    end
    return file_name,file_path
  end

  def self.rename_local_file(file)
    file_name = "img_#{rename_ext_file(file)}"
  end

  #将 Base64 文件解析成本地文件
  def self.base64_to_local(file)
    dir_path = "#{Rails.root}/public/uploads/"
    local_name = "img_#{rand_string_name(20)}.png"
    local_path = dir_path + local_name
    File.open(local_path,'wb+') do |item|
      item.write(file)
    end
    return local_name,local_path
  end

  def self.file_to_info(key)
    code, result, response_headers = Qiniu::Storage.stat(Settings.qiniu_bucket, key)
    return result
  end

  #根据文件扩展名不同生成相应的名称
  def self.rename_ext_file(file)
    ext = File.extname(file.original_filename).to_s #文件扩展名.xxx
    return rand_string_name(20) + ext
  end

  #随机生成字符串
  def self.rand_string_name(num)
    return [*'a'..'z',*'0'..'9',*'A'..'Z'].sample(num).join
  end

  #删除本地缓存文件
  def self.delete_local_cache(file)
    file_path = "#{Rails.root}/public/uploads/#{file}"
    if File.exist?(file_path)
      File.delete(file_path)
    end
  end

  #上传到七牛云服务器
  def self.upload_yun(name,path)
    bucket = Settings.qiniu_bucket
    put_policy = Qiniu::Auth::PutPolicy.new(bucket ,name) #服务器文件名称
    uptoken = Qiniu::Auth.generate_uptoken(put_policy)    #生成上传密钥
    code, result, response = Qiniu::Storage.upload_with_token_2(uptoken, path,name,nil,bucket: bucket)
    file_url = Settings.qiniu_cdn_host + name
  end

  #本地文件上传至七牛服务器
  def self.cache_to_yun(file)
    name = rename_local_file file
    file_url = upload_yun(name,file.path)
    restore_to_sql name
    return name
  end

  #剪切文件图片上传到云
  def self.base64_file_to_yun(file)
    name,path = base64_to_local(file)
    file_url = upload_yun(name,path)
    delete_local_cache name
    restore_to_sql name
    return name
  end

  #更改文件在服务器的名称
  def self.rename_yun_file_name(old_name,new_name)
    code, result, response_headers = Qiniu::Storage.move(Settings.qiniu_bucket, old_name, Settings.qiniu_bucket, new_name)
    if code != 614
      return true
    else
      return false
    end
  end

  #删除服务器的文件
  def self.delete_yun_file(name)
    code, result, response_headers = Qiniu::Storage.delete(Settings.qiniu_bucket, name)
    if code == 200
      return true
    else
      return false
    end
  end

  #同步云文件到本地服务器
  def self.synchronize(prefix,limit)
    bucket = Settings.qiniu_bucket #指定空间
    list_policy = Qiniu::Storage::ListPolicy.new(bucket,limit || 1000,prefix)
    code,result,headers = Qiniu::Storage.list(list_policy)
    cloud_files = result['items']
    cloud_files.each do |file|
      Cloud.find_or_create_by(key: file['key']) do |item|
        item.size = file['fsize']
        item.mine_type = file['mimeType']
        item.md5_value = file['hash']
        item.upload_at = Time.at(file['putTime']/10000000)
      end
    end
  end

  def self.restore_to_sql(key)
    info = file_to_info(key)
    Cloud.find_or_create_by(key: key) do |item|
      item.size = info['fsize']
      item.mine_type = info['mimeType']
      item.md5_value = info['hash']
      item.upload_at = Time.at(info['putTime']/10000000)
    end
  end

end
