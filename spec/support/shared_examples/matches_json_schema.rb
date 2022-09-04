# frozen_string_literal: true

RSpec.shared_examples 'matches json schema' do |schema|
  it 'matches json schema' do
    expect(response).to match_response_schema(schema)
  end
end
