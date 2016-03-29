Rails.application.routes.draw do
  [:v1, :v2].each do |version|
    scope "api/#{version}", module: :api do
      resources :authors
      resources :posts
      resources :comments
    end
  end
end
