# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, path: '' do
    namespace :v1 do
      resources :endpoints, only: %i[index create update destroy]
    end
  end
end
