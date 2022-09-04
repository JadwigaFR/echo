# frozen_string_literal: true

module API
  module V1
    class EndpointsController < ApplicationController
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
      before_action :set_content_type_header, only: %w[index update destroy]
      # before_action :set_accept_type_header
      before_action :find_endpoint, only: %w[update destroy]

      def index
        @endpoints = Endpoint.all

        render jsonapi: @endpoints, status: 200
      end

      def create
        endpoint = Endpoint.new(sanitized_endpoint_params.compact)

        if endpoint.save
          response.headers['Location'] = "#{request.base_url}#{endpoint.path}"
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

      def endpoint_params
        params.require(:data).permit({ attributes: [:verb, :path, { response: %i[code headers body] }] })
      end

      def sanitized_endpoint_params
        attributes = deep_compact(endpoint_params[:attributes])

        {
          verb: attributes[:verb],
          path: attributes[:path],
          response_code: attributes.dig(:response, :code),
          response_body: JSON.parse(attributes.dig(:response, :body)),
          response_headers: JSON.parse(attributes.dig(:response, :headers))
        }
      end

      def deep_compact(hash)
        hash.compact.transform_values do |value|
          next value unless value.class == Hash
          deep_compact(value)
        end.reject { |_k, v| v.empty? || v == 'null'}
      end
    end
  end
end
