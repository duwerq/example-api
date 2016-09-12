Rails.application.routes.draw do

  post 'tasks/scrape_webpage' => "tasks#scrape_webpage"
  resources :tasks, except: [:new, :edit]
  
  

end
