class Setting
  include Mongoid::Document
  field :default_approved, type: Boolean
  field :client_key, type: String
  field :notification_email, type: String

  validates :default_approved, presence: true
  validates :client_key, presence: true

  before_create do
    Setting.count == 0
  end

  def self.default_approved
    instance.default_approved
  end

  def self.client_key
    instance.client_key
  end

  def self.notification_email
    instance.notification_email
  end

  def self.instance
    self.first || self.create(default_approved: true, client_key: Digest::SHA256.hexdigest(Time.zone.now.to_s + rand.to_s))
  end
end
