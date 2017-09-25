Rails.application.routes.draw do
  get '/docs' => redirect('/apidocs/dist/index.html?url=/apidocs/api-docs.json')

  namespace :api do
    namespace :v1 do
      resources :artists
    end
  end
end
