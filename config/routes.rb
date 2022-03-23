Rails.application.routes.draw do
  root 'games#index'
  get 'games/', to: 'games#index'
  get 'games/new_game', to: 'games#new_game'
  get 'games/join', to: 'games#join'
  get 'games/:id', to: 'games#show'
  get 'games/:id/login', to: 'games#signup'
  get 'games/:id/signup', to: 'games#signup'

  post 'games/', to: 'games#create'
  post 'players/', to: 'players#create'
  post 'games/join', to: 'games#enter'
  post 'game/clear', to: 'games#clear'
  post 'game/kill', to: 'games#kill'
  post 'game/die', to: 'games#die'
  post 'game/start', to: 'games#start'
  post 'game/delete', to: 'games#delete'
  post 'games/:id/signup', to: 'players#create'
end
