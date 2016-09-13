Rails.application.routes.draw do

  post 'tasks/parse_webpage' => "tasks#parse_webpage"
  resources :tasks, except: [:new, :edit]
  
  

end
