# frozen_string_literal: true

class SerializableEndpoint < JSONAPI::Serializable::Resource
  type 'endpoints'
  attributes :verb

  attribute :path do
    "/#{@object.path}"
  end

  attribute :response do
    {
      code: @object.response_code,
      headers: @object.response_headers,
      body: @object.response_body
    }
  end
end
