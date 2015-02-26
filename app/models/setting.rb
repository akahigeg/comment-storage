class Setting
  include Mongoid::Document
  field :default_accepted, type: Boolean
  field :client_key, type: String

  def self.default_accepted
    instance.default_accepted
  end

  def self.client_key
    instance.client_key
  end

  def self.instance
    self.first || self.create(default_accepted: true, client_key: Digest::SHA256.hexdigest(Time.zone.now.to_s + rand.to_s))
  end
end
