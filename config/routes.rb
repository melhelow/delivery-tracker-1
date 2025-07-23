Rails.application.routes.draw do
  # Authentication routes
  devise_for :users

  # Home page should show deliveries
  root "deliveries#index"

  # Custom routes for Deliveries CRUD

  # CREATE
  post '/insert_delivery', to: 'deliveries#create'


  # READ
  get("/deliveries", { :controller => "deliveries", :action => "index" })
  get("/deliveries/:path_id", { :controller => "deliveries", :action => "show" })

  # UPDATE
  post "/modify_delivery/:path_id", to: "deliveries#update"

  # DELETE
  delete "/delete_delivery/:path_id", to: "deliveries#destroy"

end
