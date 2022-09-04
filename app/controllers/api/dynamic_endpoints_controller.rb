# frozen_string_literal: true

module API
  class DynamicEndpointsController < ApplicationController
    before_action :find_endpoint

    def dispatch_request
      # binding.pry
      case @endpoint.verb
      when 'GET'
        handle_get_request
      end
    end

    def handle_get_request
      @endpoint.response_headers.each do |key, value|
        response.set_header(key, value)
      end

      # binding.pry
      render json: @endpoint.response_body, status: @endpoint.response_code
    end

    private

    def find_endpoint
      verb = request.request_method
      path = params[:path]
      # binding.pry
      @endpoint = Endpoint.find_by!(path:, verb:)
    end

    def record_not_found
      render jsonapi_errors: {
        code: 'not_found',
        detail: "Requested page `#{params[:path]}` does not exist"
      }, status: 404
    end
  end
end

