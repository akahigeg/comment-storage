class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  field :location, type: String
  field :username, type: String
  field :content, type: String
  field :mail, type: String
  field :link, type: String
  field :remote_ip, type: String
  field :accepted, type: Boolean, default: true

  validates :username, presence: true
  validates :content, presence: true
end