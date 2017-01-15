class CommentsController < ApplicationController
  #force_ssl if: :ssl_configured?

  def ssl_configured?
    !Rails.env.development?
  end

  def create
    @comment = Comment.create(comment_params)
    UserActionLog.generate(current_user,3,@comment.id,request.remote_ip) if @comment.reply_id.nil?
    UserActionLog.generate(current_user,4,@comment.id,request.remote_ip) if @comment.reply_id.present?
    render 'comments/user_comment', layout:false
  end

  def com_vote
    @comment = Comment.find(params[:id])
    @comment.increment!(:vote)
    UserActionLog.generate(current_user,6,@comment.id,request.remote_ip)
    render json:{msg:'感谢您的点赞',sum:@comment.vote}
  end

  private

    def comment_params
      params.require(:comment).permit(:user_id, :reply_id, :video_id, :vote, :content)
    end
end