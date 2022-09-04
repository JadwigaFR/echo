# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  before_action :check_basic_authentication

  private

  def check_basic_authentication
    return true if authentication_token_valid?

    render jsonapi_errors: { code: 'unauthorized', detail: 'Invalid bearer token' }, status: 401
  end

  def api_token
    Rails.application.credentials.api_token
  end

  def authentication_token_valid?
    return false unless request.authorization

    ActiveSupport::SecurityUtils.secure_compare(
      "Bearer #{api_token}",
      request.authorization
    )
  end
end
