Rails.application.routes.draw do
  root 'splash_screen#splash'
  get '/splash', to: 'splash_screen#splash'

  resources :users
  resources :groups, :path => "categories" do 
    resources :expenses, :path => "transactions"
  end
  devise_for :users

  devise_scope :user do
    #root to: 'devise/sessions#new'
  end

  resources :users do
    resources :categories, controller: 'groups', as: 'groups' do
      resources :transactions, controller: 'expenses', as: 'expenses'
    end
  end
end
