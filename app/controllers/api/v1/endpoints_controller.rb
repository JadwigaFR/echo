# frozen_string_literal: true

module API
  module V1
    class EndpointsController < ApplicationController
      before_action :set_headers

      def index
        @endpoints = Endpoint.all

        render jsonapi: @endpoints, status: 200
      end

      private

      def set_headers
        response.headers['Content-Type'] = 'application/vnd.api+json'
      end
    end
  end
end
