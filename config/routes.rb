Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get '/', to: 'snippets#new', as: :home
  resources :snippets, only: [:new, :create, :show], param: :short_code
  get '/raw/:short_code', to: 'snippets#raw', as: :snippet_raw
end
