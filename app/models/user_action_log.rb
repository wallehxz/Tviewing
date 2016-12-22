  # t.integer  "user_id",    limit: 4
  # t.string   "action",     limit: 255
  # t.string   "result",     limit: 255
  # t.string   "local_ip",   limit: 255
  # t.string   "location",   limit: 255

class UserActionLog < ActiveRecord::Base
  belongs_to :user, foreign_key:'user_id'
  self.per_page = 10
  scope :latest, -> { order(created_at: :desc)}

  def self.generate(user,action,result,ip)
    log = UserActionLog.new
    log.user_id = user.present?? user.id : 0
    log.action = action
    log.result = result
    log.local_ip = ip
    puts ip
    # log.location = User.cx_location(ip) if ip != '127.0.0.1'
    log.save
  end

  def action_name
    {1=>'网页浏览',2=>'观看视频',3=>'视频评论',4=>'回复评论',5=>'账户登录',6=>'评论点赞',7=>'用户注册'}[self.action.to_i]
  end

  def user_name
    return self.location.present??  self.location + '用户' : '匿名用户' if self.user_id == 0
    return  self.user.display_name if self.user_id != 0
  end

end
