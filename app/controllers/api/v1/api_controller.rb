module API
  module V1
    class APIController < ActionController::API

      before_action :validate_api_key

      def validate_api_key
        @api_key = APIKey.active.find_by(key: bearer_token)
        if @api_key
          @current_user = @api_key.user
          @log = @api_key.api_request_logs.create(
            endpoint: request.path, request_method: request.request_method, payload: request.body
          )
        else
          handle_response({ error: 'Unauthorized' }, status: 403)
        end
      end

      def handle_response(body, status: 200)
        @log.update(response_code: status, response_body: body)

        render json: body, status: status
      end

      private

      def bearer_token
        request.authorization.to_s[/\ABearer (.+)\z/, 1]
      end
    end
  end
end
