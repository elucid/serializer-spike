Rails.application.routes.draw do
  namespace :api do
    [:v1, :v2].each do |version|
      namespace version do
        resources :authors
        resources :posts
        resources :comments
      end
    end
  end
end
