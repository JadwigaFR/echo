# frozen_string_literal: true

require 'rails_helper'

describe API::DynamicEndpointsController, type: :request do
  describe 'GET requests' do
    context 'when the endpoint exist' do
      let!(:endpoint) do
        create(:endpoint,
               verb: 'GET',
               path: 'test-path',
               response_code: 410,
               response_body: '{"message"=>"I am gone"}',
               response_headers: { 'Gone-status' => 'never-to-return' })
      end

      before { get '/test-path', params: { path: 'test-path' } }

      it 'returns the correct headers' do
        subject
        expect(headers['Gone-status']).to eql('never-to-return')
      end

      it 'responds with the correct response_code' do
        subject
        expect(response.status).to eq(410)
      end

      it 'responds with the correct body' do
        subject
        expect(response.body).to eq('{"message"=>"I am gone"}')
      end
    end

    context 'with the wrong verb' do
      let!(:endpoint) do
        create(:endpoint,
               verb: 'GET',
               path: 'test-path',
               response_code: 410,
               response_body: '{"message"=>"I am gone"}',
               response_headers: { 'Gone-status' => 'never-to-return' })
      end

      before { post '/test-path', params: { path: 'test-path' } }
      include_examples 'matches json schema', 'errors'
      it 'returns not found error' do
        expect(response_json['errors'].first['code']).to eql('not_found')
      end
    end

    context 'when the endpoint can\'t be found' do
      before { post '/no-exist', params: { path: 'no-exist' } }
      include_examples 'matches json schema', 'errors'
      it 'returns not found error' do
        expect(response_json['errors'].first['code']).to eql('not_found')
      end
    end
  end
end
