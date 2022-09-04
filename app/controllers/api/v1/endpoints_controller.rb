# frozen_string_literal: true

module API
  module V1
    class EndpointsController < ApplicationController
      before_action :set_headers

      def index
        @endpoints = Endpoint.all

        render jsonapi: @endpoints, status: 200
      end

      def create
        endpoint = Endpoint.new(sanitized_endpoint_params.compact)

        if endpoint.save
          render jsonapi: endpoint, status: 201
        else
          render jsonapi_errors: endpoint.errors, status: 400
        end
      end

      private

      def set_headers
        response.headers['Content-Type'] = 'application/vnd.api+json'
      end

      def endpoint_params
        params.require(:data).permit({ attributes: [:verb, :path, { response: %i[code headers body] }] })
      end

      def sanitized_endpoint_params
        attributes = deep_compact(endpoint_params[:attributes])

        {
          verb: attributes[:verb],
          path: attributes[:path],
          response_code: JSON.parse(attributes.dig(:response, :code)),
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
