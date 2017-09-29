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
          put :add_song
          put :delete_song
        end
      end

      resources :playlists do
        member do
          put :add_song
          put :delete_song
        end
      end
    end
  end
end
