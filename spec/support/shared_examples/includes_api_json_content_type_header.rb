# frozen_string_literal: true

RSpec.shared_examples 'includes content type headers' do
  it 'includes jsonapi type in response\'s headers' do
    expect(response.headers['Content-Type']).to eql('application/vnd.api+json')
  end
end
