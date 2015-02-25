class CommentsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers

  # For all responses in this controller, return the CORS access control headers.
  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  # If this is a preflight OPTIONS request, then short-circuit the
  # request, return only the necessary headers and return an empty
  # text/plain.

  def cors_preflight_check
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version'
    headers['Access-Control-Max-Age'] = '1728000'
  end

  def index
    render :json => Comment.where(location: params[:location]).all
  end

  def create
    params = {
      username: comment_params[:username],
      content:  comment_params[:content],
      location: comment_params[:location],
      accepted: Setting.first.default_accepted
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
end
