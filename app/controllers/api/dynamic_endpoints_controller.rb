# frozen_string_literal: true

module API
  class DynamicEndpointsController < ApplicationController
    before_action :find_endpoint, :set_headers

    def dispatch_request
      render json: @endpoint.response_body, status: @endpoint.response_code
    end

    private

    def set_headers
      @endpoint.response_headers.each do |key, value|
        response.set_header(key, value)
      end
    end

    def find_endpoint
      verb = request.request_method
      path = params[:path]

      @endpoint = Endpoint.find_by!(path: path, verb: verb)
    end

    def record_not_found
      render jsonapi_errors: {
        code: 'not_found',
        detail: "Requested page `#{params[:path]}` does not exist"
      }, status: 404
    end
  end
end
