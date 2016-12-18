# t.string   "email",                  limit: 255, default: "", null: false
# t.string   "encrypted_password",     limit: 255, default: "", null: false
# t.integer  "role",                   limit: 4,   default: 1
# t.string   "reset_password_token",   limit: 255
# t.datetime "reset_password_sent_at"
# t.datetime "remember_created_at"
# t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
# t.datetime "current_sign_in_at"
# t.datetime "last_sign_in_at"
# t.string   "current_sign_in_ip",     limit: 255
# t.string   "last_sign_in_ip",        limit: 255
# t.string   "nick_name",              limit: 255
# t.string   "avatar",                 limit: 255
# t.string   "phone",                  limit: 255
# t.string   "location",               limit: 255

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable, :validatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  before_create :set_admin, :set_nick_name, :set_avatar
  scope :recent, -> {order(updated_at: :desc)}
  self.per_page = 10

  def admin?
    return true if self.role == 0
    return false
  end

  def adult?
    return true if self.role != 1
    return false
  end

  def nonage?
    return true if self.role == 1
    return false
  end

  def set_admin
    self.update_attributes(role:0) if self.id == 1
  end

  def set_nick_name
    self.nick_name = Comment::Name[rand(77)]
  end

  def set_avatar
    self.avatar = "lol/#{rand(76)}.jpg"
  end

  def display_name
    return self.nick_name if self.nick_name.present?
    return self.email.split('@')[0]
  end

  def self.baidu_location(ip)
    baidu_json = $baidu_location.get do |req|
      req.url '/location/ip'
      req.params['ip'] = ip
      req.params['ak'] = '5PELDwT7pnzGDOjTjrV5oGq8'
    end
    body = JSON.parse(baidu_json.body)
    return body['content']['address'] if body['status'] == 0
    return '地球村'
  end

  # User.cx_location('')
  def self.cx_location(ip)
    url = 'http://api.ip138.com/query/'
    app_code = 'f910da9ce9ac0b40625c43f372363fac'
    res = Faraday.get do |req|
      req.url url
      req.params[:ip] = ip
      req.headers[:token] = app_code
    end
    info = JSON.parse(res.body)
    address = info['data']
    return zh_location(address[0],address[1],address[2]) if info['ret'] == 'ok'
    return baidu_location(ip)
  end

  def self.zh_location(coun,prov,city)
    if coun != prov && prov != city
      return coun + prov + city
    elsif coun == prov
      return coun + city
    elsif prov == city
      return coun + city
    end
  end
end
