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
    Webhook.create(hook_type:, payload:, wiki:, wiki_user:)
  end

  private

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
