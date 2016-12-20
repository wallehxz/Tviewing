module ApplicationHelper

  def model_errors(model,attribute)
    return model.errors.messages[attribute.to_sym][0] if model.errors.messages[attribute.to_sym]
  end

  def display_role(user)
    return '老司机' if user.role==0
    return '鉴黄师' if user.role==2
    return '小盆友' if user.role==1
  end

  def display_video_type(video)
    return '优酷视频' if video.video_type == 0
    return '腾讯视频' if video.video_type == 1
    return '奇艺视频' if video.video_type == 2
    return '文件视频' if video.video_type == 3
  end

  def role_bg_label(user)
    return 'btn bg-purple btn-flat' if user.role==0
    return 'btn bg-orange btn-flat' if user.role==1
    return 'btn bg-navy btn-flat' if user.role==2
  end

  def rand_lol_picture(num)
    return image_path("lol/#{num}.jpg")
  end

  def display_avatar(user)
    return rand_lol_picture(rand(77)) if user.avatar.nil?
    return image_path(user.avatar) if user.avatar.present? && user.avatar.include?('lol')
    return Settings.qiniu_cdn_host + user.avatar
  end

  def display_name(user)
    return user.nick_name if user.nick_name.present?
    return user.email.split('@')[0]
  end

  def video_time(time)
    if time.to_i >= 60
      return "#{time.to_i / 60} 分钟"
    else
      return "#{time.to_i} 秒"
    end
  end

  def video_cover(url)
    return "#{Settings.qiniu_cdn_host + url}!300x160"
  end

  def carousel_cover(url)
    return "#{Settings.qiniu_cdn_host + url}!1200x525"
  end

  def carousel_avatar_cover(url)
    return "#{Settings.qiniu_cdn_host + url}!100x100"
  end

  def list_cover(url)
    return "#{Settings.qiniu_cdn_host + url}!300x150"
  end

  def column_avatar(url)
    return "#{Settings.qiniu_cdn_host + url}!1920x525"
  end

  def pre_cover(url)
    return "#{Settings.qiniu_cdn_host + url}" if url.present?
  end

  def rand_background(num)
    ['danger','warning','info','primary'][num]
  end

  def rank_picture(user)
    num = user.sign_in_count
    if num < 10
      return image_path('rank/rank-1.png')
    elsif num >= 10 && num < 30
      return image_path('rank/rank-2.png')
    elsif num >= 30 && num < 70
      return image_path('rank/rank-3.png')
    elsif num >= 70 && num < 130
      return image_path('rank/rank-4.png')
    elsif num >= 130 && num < 210
      return image_path('rank/rank-5.png')
    elsif num >= 210 && num < 350
      return image_path('rank/rank-6.png')
    elsif num >= 350
      return image_path('rank/rank-7.png')
    end
  end

  def rank_name(user)
    num = user.sign_in_count
    if num < 10
      return '英勇黄铜'
    elsif num >= 10 && num < 30 #20
      return '不屈白银'
    elsif num >= 30 && num < 70  #40
      return '荣耀黄金'
    elsif num >= 70 && num < 130  #60
      return '华贵铂金'
    elsif num >= 130 && num < 210  #80
      return '璀璨钻石'
    elsif num >= 210 && num < 350
      return '超凡大师'
    elsif num >= 350
      return '最强王者'
    end
  end

  def file_display_pictrue(file)
    return Settings.qiniu_cdn_host + file.key + '!300x150' if file.mine_type.include?('image')
    return image_path('toutu/video.png') if file.mine_type.include?('video')
    return image_path('toutu/file.png')
  end

  def com_l_or_r(com)
    return 'right-com' if current_user && com.user_id == current_user.id
    return 'right-com' if com.reply_id.present?
    return 'left-com'
  end

  def fix_r_com(com)
    return 'right_com' if current_user && com.user_id == current_user.id
    return 'right_com' if com.reply_id.present?
  end

  def com_user_name(com)
    return Comment.rand_name if com.user_id == 0
    return display_name(com.user)
  end

  def come_user_avatar(com)
    return rand_lol_picture(rand(77)) if com.user_id == 0
    return display_avatar(com.user)
  end

  def com_reply_tip(com)
    return "回复 <a style='color:#6699FF;'>#{com.reply.display_name}</a> 的评论 ：<br/><br/>".html_safe if com.reply_id.present?
  end

  def default_com_name
    return "以 [#{current_user.display_name}] 评论" if current_user
    return '以路人甲身份评论'
  end

end
