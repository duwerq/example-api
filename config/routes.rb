Rails.application.routes.draw do

  root 'tasks#new'
  resources :tasks, except: [:edit]
  
  

end
