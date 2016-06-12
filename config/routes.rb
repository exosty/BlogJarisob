Rails.application.routes.draw do

  root 'posts#index'

  devise_for :users
  resources :tags
  resources :posts do
    resources :comments
    member do
      put 'like' => 'posts#like'
      put 'unlike' => 'posts#unlike'
      put 'vote' => 'posts#vote'
      put 'unvote' => 'posts#unvote'
    end
  end
  get 'favorite', to: 'posts#favorite'

end
