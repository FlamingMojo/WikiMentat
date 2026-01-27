class WebhooksController < ActionController::Base
  skip_before_action :verify_authenticity_token, only: %i[create]

  def create
    @webhook = WebhookFactory.create(webhook_params.to_h.with_indifferent_access)

    if @webhook.persisted?
      render json: { ok: true }, status: :created
    else
      render json: { ok: false }, status: :not_acceptable
    end
  end

  private

  def webhook_params
    params.permit(:wiki, :hook, user: {}, page: {})
  end
end

# NEXT UP - DISCORD MESSAGE WEBHOOK PARSER AND SENDER
