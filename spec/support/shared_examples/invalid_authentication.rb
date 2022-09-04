# frozen_string_literal: true

RSpec.shared_examples 'invalid authentication' do
  context 'when the bearer token is invalid' do
    before { request.headers.merge!('Authorization' => 'Bearer 123-123-123-123123') }
    include_examples 'matches json schema', 'errors'
    include_examples 'returns correct status code', 401

    it 'returns not found error' do
      expect(response_json['errors'].first['code']).to eql('unauthorized')
    end
  end
end
