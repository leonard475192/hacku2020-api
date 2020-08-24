Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :users
      resources :todos
      get 'login/login'
      post 'login/login'
      post 'todos/destroy_all'
    end
  end
end
