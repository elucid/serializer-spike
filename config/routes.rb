Rails.application.routes.draw do
  scope 'api/v1', module: 'api' do
    resources :authors
    resources :posts
    resources :comments
  end
end
