Rails.application.routes.draw do
  #get '/docs' => redirect('/apidocs/dist/index.html?url=/apidocs/api-docs.json')
  root to: redirect('/apidocs/dist/index.html?url=/apidocs/api-docs.json')
  namespace :api do
    namespace :v1 do
      resources :artists

      resources :songs do
        member do
          put :feature
          put :unfeature
        end
      end

      resources :albums do
        member do
          put :add_songs
          put :delete_songs
        end
      end

      resources :playlists do
        member do
          put :add_songs
          put :delete_songs
        end
      end
    end
  end
end
