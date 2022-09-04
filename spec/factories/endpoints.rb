# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :endpoint do
    verb { 'GET' }
    path { '/test' }
    response_code { 200 }
    response_headers { { my_customized_key: 'my_customized_value' } }
    response_body { Faker::GreekPhilosophers.quote }

    trait :post do
      verb { 'POST' }
      response_code { 201 }
    end

    trait :put do
      verb { 'PUT' }
      response_code { 200 }
    end

    trait :delete do
      verb { 'PUT' }
      response_code { 200 }
    end

    trait :without_body do
      response_body { nil }
    end
  end
end
