RSpec.shared_examples 'returns correct status code' do |status_code|
  it "returns a #{status_code} status code" do
    expect(response.status).to eq(status_code)
  end
end
