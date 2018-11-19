Rails.application.routes.draw do
namespace :api do
  namespace :v1 do
    post 'freepbx/create', to: '/api/v1/freepbx#create'
    put 'freepbx/update', to: '/api/v1/freepbx#update'
  end
end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
