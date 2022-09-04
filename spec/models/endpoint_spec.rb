# frozen_string_literal: true

require 'rails_helper'

describe Endpoint, type: :model do
  describe 'validations' do
    context 'with valid attributes' do
      subject(:endpoint) { Endpoint.new(verb: 'GET', path: '/path', response_code: 200) }
      it { is_expected.to be_valid }
    end

    context 'with an invalid HTTP verb' do
      subject(:endpoint) { Endpoint.new(verb: 'DO', path: '/path', response_code: 200) }
      it { is_expected.not_to be_valid }
    end

    context 'with an invalid response code' do
      subject(:endpoint) { Endpoint.new(verb: 'DO', path: '/path', response_code: 666) }
      it { is_expected.not_to be_valid }
    end

    context 'without a verb' do
      subject(:endpoint) { Endpoint.new(path: '/path', response_code: 200) }
      it { is_expected.not_to be_valid }
    end

    context 'without a path' do
      subject(:endpoint) { Endpoint.new(verb: 'GET', response_code: 200) }
      it { is_expected.not_to be_valid }
    end

    context 'without a response_code' do
      subject(:endpoint) { Endpoint.new(verb: 'GET', path: '/path') }
      it { is_expected.not_to be_valid }
    end
  end
end
