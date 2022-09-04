# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, path: '' do
    namespace :v1 do
      resources :endpoints, only: %i[index create update destroy]
    end

    get ':path', to: 'dynamic_endpoints#dispatch_request'
    post ':path', to: 'dynamic_endpoints#dispatch_request'
    patch ':path', to: 'dynamic_endpoints#dispatch_request'
    put ':path', to: 'dynamic_endpoints#dispatch_request'
    delete ':path', to: 'dynamic_endpoints#dispatch_request'
  end
end
