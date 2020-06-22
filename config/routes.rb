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
    collection do
      get '/:year/:month/all', action: :all, as: :all_month, constraints: { year: /\d+/, month: /\d+/ }
      get '/:year/:month', action: :index, as: :my_month, constraints: { year: /\d+/, month: /\d+/ }
    end
  end

  root to: 'events#index'

end
