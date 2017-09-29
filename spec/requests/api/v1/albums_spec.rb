require 'rails_helper'

RSpec.describe 'Api::V1::Albums', type: :request do
  let!(:artist) { create(:artist) }
  let!(:albums) { create_list(:album, 10, artist: artist) }
  let(:album) { albums.first }
  let(:album_id) { albums.first.id }

  # Test suite for GET /albums
  describe 'GET /albums' do
    before { api_get '/albums' }

    it 'returns albums' do
      expect(json_response).not_to be_empty
      expect(json_response.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /albums/:id
  describe 'GET /albums/:id' do
    before { api_get "/albums/#{album_id}" }

    context 'when the record exists' do
      it 'returns the album' do
        expect(json_response).not_to be_empty
        expect(json_response['id']).to eq(album_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:album_id) { "not_exists" }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Album/)
      end
    end
  end

  # Test suite for POST /albums
  describe 'POST /albums' do
    let(:album_name) { 'The Beatles' }
    let(:valid_attributes) { { name: album_name, artist_id: artist.id } }

    context 'when the request is valid' do
      before { api_post '/albums', params: valid_attributes }

      it 'creates an album' do
        expect(json_response['name']).to eq(album_name)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { api_post '/albums', params: {  } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: /)
      end
    end
  end

  # Test suite for PUT /albums/:id
  describe 'PUT /albums/:id' do
    let(:new_name) { FFaker::Music.album }
    let(:valid_attributes) { { name: new_name } }

    context 'when the record exists' do
      before { api_put "/albums/#{album_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'PUT /albums/:id/add_song' do
    let!(:new_song) { create(:song, owner_id: artist.id) }
    let(:new_song_id) { new_song.id }
    let(:attributes) {
      {
        song_id: new_song_id
      }
    }

    context 'when the album does not have the song' do
      before { api_put "/albums/#{album_id}/add_song", params: attributes }

      it 'should respond with no content' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'should add a new song to the album' do
        album.reload
        expect(album.songs.count).to eq(1)
        expect(album.songs.last).to eq(new_song)
      end
    end

    context 'when the album already has the song' do
      before do
        album.add_song!(new_song_id)
        api_put "/albums/#{album_id}/add_song", params: attributes
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: /)
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'should not add a new song to the album' do
        album.reload
        expect(album.songs.count).to eq(1)
      end
    end
  end

  describe 'PUT /albums/:id/delete_song' do
    let!(:added_song) { create(:song, owner_id: artist.id) }
    let(:added_song_id) { added_song.id }
    let(:attributes) {
      {
        song_id: added_song_id
      }
    }

    # context 'when the album does not have the song' do
    #   before { api_put "/albums/#{album_id}/delete_song", params: attributes }
    #
    # it 'returns a validation failure message' do
    #   expect(response.body)
    #     .to match(/Validation failed: /)
    # end
    #
    # it 'returns status code 422' do
    #   expect(response).to have_http_status(422)
    # end
    # end

    context 'when the album already has the song' do
      before do
        album.add_song!(added_song_id)
        api_put "/albums/#{album_id}/delete_song", params: attributes
      end

      it 'should respond with no content' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'should delete the song from the album' do
        album.reload
        expect(album.songs.count).to eq(0)
      end
    end
  end

  # Test suite for DELETE /albums/:id
  describe 'DELETE /albums/:id' do
    before { api_delete "/albums/#{album_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
