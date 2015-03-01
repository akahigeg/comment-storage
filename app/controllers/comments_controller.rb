class CommentsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :verify_client_key

  def index
    render :json => Comment.where(location: params[:location], accepted: true).all
  end

  def create
    comment = comment_params.merge({
      accepted: Setting::default_accepted,
      remote_ip: request.env["HTTP_X_FORWARDED_FOR"] || request.remote_ip
    })
    begin
      new_comment = Comment.create(comment)
      if new_comment.errors.blank?
        if Setting::default_accepted
          render :json => new_comment
        else
          render :json => {username: 'admin', content: 'This comment is waiting to be accepted.'}
        end
      else
        render :json => {username: 'Error', content: new_comment.errors.full_messages}
      end
    rescue
      render :json => {username: 'Error', content: 'Comment failed'}
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:username, :content, :location, :mail, :link)
  end

  def verify_client_key
    render(text: "404 Not Found", status: 404) unless Setting::client_key == params[:client_key]
  end
end
