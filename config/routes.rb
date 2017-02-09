Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope '', defaults: {format: :json}, controller: :api do
  	get 'latest/:attrs', action: :latest, as: :latest
  	get 'historical/:attrs', action: :historical, as: :historical
  end

  root '/', controller: :application, action: :home

  get 'historical_data', controller: :application, action: :historical_data
  get 'list', controller: :application
end
