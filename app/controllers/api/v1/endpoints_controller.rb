# frozen_string_literal: true

module API
  module V1
    class EndpointsController < ApplicationController
      before_action :set_content_type_header, only: %w[index create update]
      before_action :find_endpoint, only: %w[update destroy]

      def index
        @endpoints = Endpoint.all

        render jsonapi: @endpoints, status: 200
      end

      def create
        endpoint = Endpoint.new(sanitized_endpoint_params)

        if endpoint.save
          response.headers['Location'] = "#{request.base_url}/#{endpoint.path}"
          render jsonapi: endpoint, status: 201
        else
          render jsonapi_errors: endpoint.errors, status: 400
        end
      end

      def update
        @endpoint.update(sanitized_endpoint_params)

        if @endpoint.save
          render jsonapi: @endpoint, status: 200
        else
          render jsonapi_errors: @endpoint.errors, status: 400
        end
      end

      def destroy
        @endpoint.destroy

        render jsonapi: nil, status: 204
      end

      private

      def record_not_found
        render jsonapi_errors: {
          code: 'not_found',
          detail: "Requested Endpoint with ID `#{params[:id]}` does not exist"
        }, status: 404
      end

      def set_content_type_header
        response.headers['Content-Type'] = 'application/vnd.api+json'
      end

      def find_endpoint
        @endpoint = Endpoint.find(params[:id])
      end

      def sanitized_endpoint_params
        EndpointParamsSanitizer.call(endpoint_params)
      end

      def endpoint_params
        params.require(:data).permit({ attributes: [:verb, :path, { response: %i[code headers body] }] })
      end
    end
  end
end
