# == Schema Information
#
# Table name: columns
#
#  id         :integer          not null, primary key
#  name       :string
#  english    :string
#  icon       :string
#  cover      :string
#  summary    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'csv'
class Column < ActiveRecord::Base
  validates_presence_of :name, :english, :icon
  validates_uniqueness_of :name, :english
  has_many :videos, :dependent => :destroy
  scope :latest, ->{ order(updated_at: :desc) }
  scope :recent, ->{ order(created_at: :desc) }
  scope :general, ->{ where("id != 1")}
  scope :qvode, ->{ where("id == 1")}
  scope :asc_id, ->{ order(id: :asc) }
  scope :desc_id, ->{ order(id: :desc) }

  def self.picture_url(file)
    if file.present?
      return Cloud.cache_to_yun(file)
    else
      return nil
    end
  end

  def self.to_csv_data(videos)
    CSV.generate do |csv|
      num = 0
      csv << ["\xEF\xBB\xBF序号",'视频类别','视频标题','优酷链接','视频头图'] #解决乱码
      videos.each do |item|
        num += 1
        csv << [num,item.title,item.video_type,item.youku_id,item.video_cover]
      end
    end
  end

  def self.file_or_url(file,url)
    return Cloud.cache_to_yun(file) if file.present?
    return url if file.nil?
  end

  def recommend
    return self.videos.where(recommend:1).first if self.videos.where(recommend:1).first.present?
    return self.videos.order(created_at: :desc).first
  end
end
