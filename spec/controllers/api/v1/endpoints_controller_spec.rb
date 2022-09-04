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
end
