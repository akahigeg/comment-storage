class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  field :location, type: String
  field :username, type: String
  field :content, type: String
  field :accepted, type: Boolean, default: true
end