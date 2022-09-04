# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, path: '' do
    namespace :v1 do
      resources :endpoints, only: %i[index create update destroy]
    end

    match '*path', to: 'dynamic_endpoints#dispatch_request', via: %i[get post put patch delete]
  end
end
