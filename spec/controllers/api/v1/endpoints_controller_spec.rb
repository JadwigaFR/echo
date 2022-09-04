# frozen_string_literal: true

require 'rails_helper'

describe API::V1::EndpointsController, type: :controller do
  shared_examples 'includes correct headers' do
    it 'includes jsonapi type in response\'s headers' do
      expect(response.headers['Content-Type']).to eql('application/vnd.api+json')
    end
  end

  shared_examples 'matches json schema' do |schema|
    it 'matches json schema' do
      expect(response).to match_response_schema(schema)
    end
  end

  shared_examples 'returns correct status code' do |status_code|
    it "returns a #{status_code} status code" do
      expect(response.status).to eq(status_code)
    end
  end

  shared_examples 'returns an invalid field error' do |field|
    it 'returns validation error' do
      expect(response_json['errors'].first['title']).to eql("Invalid #{field}")
    end
  end

  describe '#index' do
    subject(:response) { get :index }
    include_examples 'includes correct headers'

    context 'when there are no endpoints to list' do
      include_examples 'matches json schema', 'endpoints'
      include_examples 'returns correct status code', 200

      it 'returns an empty array' do
        expect(response_json['data']).to eql([])
      end
    end

    context 'when there are endpoints to list' do
      include_examples 'matches json schema', 'endpoints'
      include_examples 'returns correct status code', 200
      let!(:endpoint) { create_list(:endpoint, 5) }

      it 'returns all the endpoints' do
        expect(response_json['data'].count).to eql(5)
      end
    end
  end

  describe '#create' do
    subject(:response) { post :create, params: }
    let(:params) do
      {
        "data": {
          "type": 'endpoints',
          "attributes": {
            "verb": 'GET',
            "path": '/greeting',
            "response": {
              "code": 200,
              "headers": '{"a_key":"a_value"}',
              "body": '{"message":"Hello, world"}'
            }
          }
        }
      }
    end

    include_examples 'includes correct headers'

    context 'with valid params' do
      include_examples 'returns correct status code', 201
      include_examples 'matches json schema', 'endpoint'

      it 'assigns endpoint attributes based on params' do
        response

        endpoint = Endpoint.last
        expect(endpoint.verb).to eql('GET')
        expect(endpoint.path).to eql('/greeting')
        expect(endpoint.response_code).to eql(200)
        expect(endpoint.response_headers).to eql({ 'a_key' => 'a_value' })
        expect(endpoint.response_body).to eql('{"message"=>"Hello, world"}')
      end
    end

    context 'with only required valid params' do
      before { params[:data][:attributes].merge!(response: { "code": 201, "headers": 'null', "body": 'null' }) }
      include_examples 'returns correct status code', 201
      include_examples 'matches json schema', 'endpoint'

      it 'assigns default values for null attributes' do
        response

        endpoint = Endpoint.last
        expect(endpoint.verb).to eql('GET')
        expect(endpoint.path).to eql('/greeting')
        expect(endpoint.response_code).to eql(201)
        expect(endpoint.response_headers).to eql({})
        expect(endpoint.response_body).to eql(nil)
      end
    end

    context 'with invalid params' do
      context 'when verb is invalid' do
        before { params[:data][:attributes].merge!(verb: 'DO') }
        include_examples 'matches json schema', 'errors'
        include_examples'returns an invalid field error', 'verb'
        include_examples 'returns correct status code', 400
      end

      context 'when response_code is invalid' do
        before { params[:data][:attributes].merge!(response: { "code": 666, "headers": 'null', "body": 'null' }) }
        include_examples 'matches json schema', 'errors'
        include_examples'returns an invalid field error', 'response_code'
        include_examples 'returns correct status code', 400
      end

      context 'when response_code is missing' do
        before { params[:data][:attributes].merge!(response: { "code": 'null', "headers": 'null', "body": 'null' }) }
        include_examples 'matches json schema', 'errors'
        include_examples'returns an invalid field error', 'response_code'
        include_examples 'returns correct status code', 400
      end

      context 'when response_code is missing' do
        before { params[:data][:attributes].merge!(verb: 'null') }
        include_examples 'matches json schema', 'errors'
        include_examples'returns an invalid field error', 'verb'
        include_examples 'returns correct status code', 400
      end
    end
  end
end
