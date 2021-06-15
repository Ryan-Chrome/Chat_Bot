Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "bots#index"

  post "/bots/counter_callback" => "bots#counter_callback"
  post "/bots/youtube_search_callback" => "bots#youtube_search_callback"
  post "/bots/youtube_list_callback" => "bots#youtube_list_callback"
end
