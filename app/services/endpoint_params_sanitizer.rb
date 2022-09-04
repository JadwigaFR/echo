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
      path: path,
      response_code: attributes.dig(:response, :code),
      response_body: body,
      response_headers: headers
    }.compact
  end

  def path
    path_attr = @params.dig(:attributes, :path)
    return nil unless path_attr

    path_attr[0] == '/' ? path_attr[(1..-1)] : path_attr
  end

  def headers
    headers_attr = @params.dig(:attributes, :response, :headers)
    return {} unless headers_attr
    JSON.parse(headers_attr)
  rescue JSON::ParserError
    headers_attr
  end

  def body
    body_attr = @params.dig(:attributes, :response, :body)
    return unless body_attr
    JSON.parse(body_attr)
  rescue JSON::ParserError
    body_attr
  end

  def deep_compact(hash)
    hash.compact.transform_values do |value|
      next value unless value.instance_of?(Hash)

      deep_compact(value)
    end.reject { |_k, v| v.empty? || v == 'null' }
  end
end
