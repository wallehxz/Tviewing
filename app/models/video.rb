# == Schema Information
#
# Table name: videos
#
# t.integer  "column_id",  limit: 4
# t.string   "url_code",   limit: 255
# t.integer  "recommend",  limit: 4,     default: 0
# t.integer  "video_type", limit: 4
# t.string   "video_url",  limit: 255,   null: false
# t.string   "title",      limit: 255
# t.string   "cover",      limit: 255
# t.string   "duration",   limit: 255
# t.text     "summary",    limit: 65535
# t.integer  "view_count", limit: 8,     default: 0

require 'csv'
class Video < ActiveRecord::Base
  validates_uniqueness_of :video_url
  validates_presence_of :column_id, :title, :cover, :video_type, :video_url
  belongs_to :column
  has_many :comments

  before_create :set_url_code
  #after_save :update_youku_comment
  before_save :truncate_video_url

  scope :latest, -> {order(updated_at: :desc)}
  scope :recent, ->{order(created_at: :desc)}
  scope :general, ->{where('column_id != 1')}
  scope :qvod, ->{where('column_id == 1')}

  self.per_page = 9

  def self.video_type_array
    [['优酷视频',0],['腾讯视频',1],['百度视频',2],['文件视频',3]]
  end

  #根据code获取优酷的视频信息 Video.code_to_youku_info
  def self.code_to_youku_info(code)
    params = { video_id:code,client_id:Settings.youku_client_id}
    response = $youku_conn.get '/v2/videos/show_basic.json', params
    return JSON.parse(response.body)
  end

  #根据 code 获取视频的热点评论 Video.code_to_hot_comment
   def self.code_to_youku_hot_comment(code,count)
     params = {client_id: Settings.youku_client_id, video_id:code, count:count}
     response = $youku_conn.get '/v2/comments/hot/by_video.json', params
     return JSON.parse(response.body)['comments']
   end

  def self.code_to_youku_comment(code,count)
    params = {client_id: Settings.youku_client_id, video_id:code, count:count}
    response = $youku_conn.get '/v2/comments/by_video.json', params
    return JSON.parse(response.body)['comments']
  end

  #截取特殊符号标题内容
  def self.truncate_title(string)
    symbol = ['」','】','》','}']
    symbol.each do |item_word|
      if string.include?(item_word)
        return (/.*(」|】|}|》)(.*)/im.match string)[2]
      end
    end
    string
  end

  #根据链接截取相应的code
  def self.youku_url_to_code(url)
    return (/id_(\w+=*)[\.]/im.match url)[1] if (/id_(\w+=*)[\.]/im.match url).present?
  end

  def self.tencent_url_to_code(url)
    return (/qq.com\/([\w,\/]+)[\.]/im.match url)[1] if (/qq.com\/([\w,\/]+)[\.]/im.match url).present?
  end

  def self.iqiyi_url_to_code(url)
    return (/v_(\w+=*)[\.]/im.match url)[1] if (/v_(\w+=*)[\.]/im.match url).present?
  end

  def self.qiniu_url_to_code(url)
    return (/_(\w+)[\.]/im.match url)[1] if (/com\/(\w+\.\w+)/im.match url).present?
  end

  #视频时长判断获取
  def self.youku_video_duration(video_url)
    return code_to_youku_info(youku_url_to_code(video_url))['duration']
  end

  #视频头图判断更新
  def self.file_or_url_to_cover(file,url)
    return Cloud.cache_to_yun(file) if file.present?
    return url
  end

  def update_youku_comment
    if self.video_type == 0 && self.comments.count < 10
      youku_id = Video.youku_url_to_code(self.video_url)
      ykh_com = Video.code_to_youku_hot_comment(youku_id,10)
      if ykh_com.length > 0
        ykh_com.each do |com|
          Comment.create!(user_id:User.all.map(&:id).sample(1)[0],video_id:self.id,vote:rand(10) + 1,content:Video.strip_emoji(com['content']))
        end
      end
      if ykh_com.length < 10
        yk_com = Video.code_to_youku_comment(youku_id,10 - ykh_com.length)
        if yk_com.length > 0
          yk_com.each do |com|
            Comment.create!(user_id:User.all.map(&:id).sample(1)[0],video_id:self.id,vote:rand(10) + 1,content:Video.strip_emoji(com['content']))
          end
        end
      end
    end
  end

  def set_url_code
    self.url_code = Cloud.rand_string_name(12)
  end

  def truncate_video_url
    if self.video_url.include?('?')
      self.video_url = self.video_url.split('?')[0]
    end
  end

  def self.to_csv(videos)
    CSV.generate do |csv|
      num = 0
      csv << ["\xEF\xBB\xBF序号",'类别','标题','链接','大图'] #解决乱码
      videos.each do |item|
        num += 1
        csv << [num,item.video_type,item.title,item.youku_id,item.video_cover]
      end
    end
  end

  def relates(number)
    Video.where(id != self.id).where(column_id:self.column_id).order("RAND()").limit(number)
  end

  def self.strip_emoji(text)
    text = text.force_encoding('utf-8').encode
    clean = ""

    # symbols & pics
    regex = /[\u{1f300}-\u{1f5ff}]/
    clean = text.gsub regex, ""

    # enclosed chars
    regex = /[\u{2500}-\u{2BEF}]/ # I changed this to exclude chinese char
    clean = clean.gsub regex, ""

    # emoticons
    regex = /[\u{1f600}-\u{1f64f}]/
    clean = clean.gsub regex, ""

    #dingbats
    regex = /[\u{2702}-\u{27b0}]/
    clean = clean.gsub regex, ""
  end

end
