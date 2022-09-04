# frozen_string_literal: true

require 'rails_helper'

describe API::DynamicEndpointsController, type: :request do
  let(:header) { { 'Authorization' => "Bearer #{Rails.application.credentials.api_token}" } }

  shared_examples 'can access dynamic endpoint' do |verb, path|
    let!(:endpoint) do
      create(:endpoint,
             verb: verb.to_s.upcase,
             path:,
             response_code: 410,
             response_body: '{"message"=>"I am gone"}',
             response_headers: { 'Gone-status' => 'never-to-return' })
    end

    before { send verb.to_sym, "/#{path}", params: { path: }, headers: header }

    it 'returns the correct headers' do
      expect(headers['Gone-status']).to eql('never-to-return')
    end

    it 'responds with the correct response_code' do
      expect(response.status).to eq(410)
    end

    it 'responds with the correct body' do
      expect(response.body).to eq('{"message"=>"I am gone"}')
    end
  end

  context 'with a get endpoint' do
    include_examples 'can access dynamic endpoint', :get, 'get-test-path'
  end

  context 'with a post endpoint' do
    include_examples 'can access dynamic endpoint', :post, 'post-test-path'
  end

  context 'with a delete endpoint' do
    include_examples 'can access dynamic endpoint', :delete, 'delete-test-path'
  end

  context 'with a put endpoint' do
    include_examples 'can access dynamic endpoint', :put, 'put-test-path'
  end

  context 'with a nested path' do
    include_examples 'can access dynamic endpoint', :get, 'get/test/path'
  end

  context 'with a v1 nested path' do
    include_examples 'can access dynamic endpoint', :get, 'v1/get/test/path'
  end

  context 'when the endpoint is not found' do
    context 'because of using the wrong http verb' do
      let!(:endpoint) do
        create(:endpoint,
               verb: 'GET',
               path: 'test-path',
               response_code: 410,
               response_body: '{"message"=>"I am gone"}',
               response_headers: { 'Gone-status' => 'never-to-return' })
      end

      before { post '/test-path', params: { path: 'test-path' }, headers: header }
      include_examples 'matches json schema', 'errors'
      include_examples 'includes content type headers'

      it 'returns not found error' do
        expect(response_json['errors'].first['code']).to eql('not_found')
      end
    end

    context 'when the endpoint can\'t be found' do
      before { post '/no-exist', params: { path: 'no-exist' }, headers: header }
      include_examples 'matches json schema', 'errors'
      include_examples 'includes content type headers'

      it 'returns not found error' do
        expect(response_json['errors'].first['code']).to eql('not_found')
      end
    end
  end
end
