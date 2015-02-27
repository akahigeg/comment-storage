class CommentsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :verify_client_key

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

  def verify_client_key
    render text: "" unless Setting::client_key == params[:client_key]
  end
end
