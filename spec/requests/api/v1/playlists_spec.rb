require 'rails_helper'

RSpec.describe 'Api::V1::Playlists', type: :request do
  let(:artist) { create(:artist) }
  let!(:playlists) { create_list(:playlist, 10) }
  let(:playlist) { playlists.first }
  let(:playlist_id) { playlists.first.id }

  # Test suite for GET /playlists
  describe 'GET /playlists' do
    before { api_get '/playlists' }

    it 'returns playlists' do
      expect(json_response).not_to be_empty
      expect(json_response.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /playlists/:id
  describe 'GET /playlists/:id' do
    before { api_get "/playlists/#{playlist_id}" }

    context 'when the record exists' do
      it 'returns the playlist' do
        expect(json_response).not_to be_empty
        expect(json_response['id']).to eq(playlist_id)
        expect(json_response['name']).to eq(playlist.name)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:playlist_id) { "not_exists" }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Playlist/)
      end
    end
  end

  # Test suite for POST /playlists
  describe 'POST /playlists' do
    let(:name) { FFaker::Music.genre + ' ' + rand(1..1000).to_s }
    let(:valid_attributes) { { name: name } }

    context 'when the request is valid' do
      before { api_post '/playlists', params: valid_attributes }

      it 'returns a playlist with valid attributes' do
        expect(json_response['id']).to be
        expect(json_response['name']).to eq(name)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { api_post '/playlists', params: {  } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: /)
      end
    end
  end

  # Test suite for PUT /playlists/:id
  describe 'PUT /playlists/:id' do
    let(:new_name) { FFaker::Music.genre + ' ' + rand(1..1000).to_s }
    let(:valid_attributes) { { name: new_name } }

    context 'when the record exists' do
      before { api_put "/playlists/#{playlist_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
        playlist.reload
        expect(playlist.name).to eq(new_name)
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'PUT /playlists/:id/add_songs' do
    let!(:new_song) { create(:song, owner_id: artist.id) }
    let!(:new_song2) { create(:song, owner_id: artist.id) }

    let(:new_song_id) { new_song.id }
    let(:new_song_id2) { new_song2.id }

    let(:attributes) {
      {
        song_ids: "#{new_song_id}, #{new_song_id2}"
      }
    }

    context 'when the playlist does not have the songs' do
      before { api_put "/playlists/#{playlist_id}/add_songs", params: attributes }

      it 'should respond with no content' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'should add the new songs to the playlist' do
        playlist.reload
        expect(playlist.songs.count).to eq(2)
        expect(playlist.songs.last).to eq(new_song2)
      end
    end

    context 'when the playlist already has the songs' do
      before do
        playlist.add_songs!([new_song_id, new_song_id2])
        api_put "/playlists/#{playlist_id}/add_songs", params: attributes
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: /)
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'should not add the new songs to the playlist' do
        playlist.reload
        expect(playlist.songs.count).to eq(2)
      end
    end
  end

  describe 'PUT /playlists/:id/delete_songs' do
    let!(:added_song) { create(:song, owner_id: artist.id) }
    let!(:added_song2) { create(:song, owner_id: artist.id) }

    let(:added_song_id) { added_song.id }
    let(:added_song_id2) { added_song2.id }

    let(:attributes) {
      {
        song_ids: "#{added_song_id}, #{added_song_id2}"
      }
    }

    context 'when the playlist already has the songs' do
      before do
        playlist.add_songs!([added_song_id, added_song_id2])
        api_put "/playlists/#{playlist_id}/delete_songs", params: attributes
      end

      it 'should respond with no content' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'should delete the songs from the playlist' do
        playlist.reload
        expect(playlist.songs.count).to eq(0)
      end
    end
  end

  # Test suite for DELETE /playlists/:id
  describe 'DELETE /playlists/:id' do
    before { api_delete "/playlists/#{playlist_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
