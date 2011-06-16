Refinery::Application.routes.draw do
  resources :events, :only => [:index, :show]

  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :events, :except => :show do
      collection do
        get :categories
        post :categories
      end
    end
  end
end
