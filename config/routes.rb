Playoday::Application.routes.draw do

  devise_for :users, skip: :registrations
  #disable canceling account
  devise_scope :user do
    resource :registration,
      only: [:new, :create, :edit, :update],
      path: 'users',
      path_names: { new: 'sign_up' },
      controller: 'devise/registrations',
      as: :user_registration do
      get :cancel
    end
  end

  resources :tournaments do
    get "register/:tournament_hash", :action => :register, :on => :collection, :as => "register"
    post "recreate_hash", :on => :member
  end

  match 'signup/:tournament_hash', :controller => :tournaments, :action => :signup, :as => :signup

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
