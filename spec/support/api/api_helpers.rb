# frozen_string_literal: true

module ApiHelpers
  def response_json
    JSON.parse(response.body)
  end
end
