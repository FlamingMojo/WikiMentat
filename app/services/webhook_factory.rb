class WebhookFactory
  attr_reader :payload
  private :payload

  def initialize(payload)
    @payload = payload
  end

  def self.create(payload)
    new(payload).create
  end

  def create
    webhook.save
  end

  private

  def webhook
    @webhook ||= Webhook.new(hook_type:, payload:, wiki:, wiki_user:)
  end

  def latest_hashes
    Webhook.last(5).map(&:payload).map(&:hash)
  end

  def hook_type
    payload[:hook]
  end

  def wiki
    @wiki ||= Wiki.find_or_create_by(url: payload[:wiki])
  end

  def wiki_user
    @wiki_user ||= wiki.wiki_users.find_or_create_by(username: payload[:user][:name])
  end
end
