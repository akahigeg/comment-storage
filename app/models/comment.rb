class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  field :location, type: String
  field :username, type: String
  field :content, type: String
  field :mail, type: String
  field :link, type: String
  field :remote_ip, type: String
  field :approved, type: Boolean, default: true
  field :commented_at, type: DateTime

  validates :location, presence: true
  validates :username, presence: true
  validates :content, presence: true
  validates :commented_at, presence: true

  before_validation do |comment|
    comment.commented_at = Time.zone.now if comment.commented_at.nil?
  end

  before_create do |comment|
    # avoid doubled comment
    Comment.where(location: comment.location, username: comment.username, content: comment.content).count == 0
  end
end