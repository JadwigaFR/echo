# frozen_string_literal: true

class EndpointParamsSanitizer
  def initialize(endpoint_params)
    @params = endpoint_params
  end

  def self.call(endpoint_params)
    new(endpoint_params).call
  end

  def call
    attributes = deep_compact(@params[:attributes])
    {
      verb: attributes[:verb]&.upcase,
      path:,
      response_code: attributes.dig(:response, :code),
      response_body: JSON.parse(attributes.dig(:response, :body)),
      response_headers: JSON.parse(attributes.dig(:response, :headers))
    }.compact
  end

  def path
    path_attr = @params[:attributes][:path]
    return nil unless path_attr

    path_attr[0] == '/' ? path_attr[(1..-1)] : path_attr
  end

  def deep_compact(hash)
    hash.compact.transform_values do |value|
      next value unless value.instance_of?(Hash)

      deep_compact(value)
    end.reject { |_k, v| v.empty? || v == 'null' }
  end
end
