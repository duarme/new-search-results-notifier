Store::Application.routes.draw do
  root to: 'products#index'
  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}
  resources :products
  resources :searches do
    member do
      put :toggle_notification
    end
    collection  do
      get :notify_new_results
    end
  end
  
  match "/nt" => 'searches#notify_new_results'
end
