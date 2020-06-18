Rails.application.routes.draw do

  devise_for :users, skip: :registrations
  devise_scope :user do
    resource :registration,
             only: %i[new create edit update],
             path: 'users',
             path_names: { new: 'sign_up' },
             controller: 'devise/registrations',
             as: :user_registration
  end

  resources :events do
    get '/:year/:month', on: :collection, action: :index, as: :month
  end

  root to: 'events#index'

end
