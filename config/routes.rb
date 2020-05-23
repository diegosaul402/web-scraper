# frozen_string_literal: true

Rails.application.routes.draw do
  resources :trials do
    match '/scrape', to: 'trials#scrape', via: :post, on: :collection
  end
  resources :notifications

  root to: 'trials#index'
end
