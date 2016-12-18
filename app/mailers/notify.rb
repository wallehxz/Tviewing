class Notify < ApplicationMailer

  def welcome(email)
    @greeting = "Hi"

    mail to: email
  end

  def new_video_generate(video,email)
    @video = video
    mail to: email,subject: "新视频信息预览"
  end
end
