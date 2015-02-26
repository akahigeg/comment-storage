class CommentsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    render :json => Comment.where(location: params[:location]).all
  end

  def create
    params = {
      username: comment_params[:username],
      content:  comment_params[:content],
      location: comment_params[:location],
      accepted: Setting::default_accepted
    }
    begin
      new_comment = Comment.create(params)
    rescue
      new_comment = nil
    end
    render :json => new_comment
  end

  private
  def comment_params
    params.permit(:username, :content, :location)
  end

  # TODO: client_keyを検証するフィルター
end
