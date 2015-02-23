class Setting
  include Mongoid::Document
  field :default_accepted, type: Boolean
  field :client_key, type: String
end
