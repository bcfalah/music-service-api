require 'rails_helper'

RSpec.describe 'Api::V1::Songs', type: :request do
  # initialize test data
  let!(:artist) { create(:artist) }
  let!(:songs) { create_list(:song, 10, owner_id: artist.id) }
  let!(:song) { songs.first }
  let(:song_id) { song.id }

  # Test suite for GET /songs
  describe 'GET /songs' do
    before { api_get '/songs' }

    it 'returns songs' do
      expect(json_response).not_to be_empty
      expect(json_response.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /songs/:id
  describe 'GET /songs/:id' do
    before { api_get "/songs/#{song_id}" }

    context 'when the record exists' do
      it 'returns the song' do
        expect(json_response).not_to be_empty
        expect(json_response['id']).to eq(song_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:song_id) { "not_exists" }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Song/)
      end
    end
  end

  # Test suite for POST /songs
  describe 'POST /songs' do
    let(:new_song) { build(:song) }
    let(:valid_attributes) { new_song.attributes.
      merge(genre_name: new_song.genre_name, owner_id: artist.id)
    }

    context 'when the request is valid' do
      before { api_post '/songs', params: valid_attributes }

      it 'creates a song' do
        valid_attributes.keys.each do |attr|
          if valid_attributes[attr].present?
            expect(json_response_hash[attr]).to eq(valid_attributes[attr])
          end
        end
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { api_post '/songs', params: {  } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: /)
      end
    end
  end

  # Test suite for PUT /songs/:id
  describe 'PUT /songs/:id' do
    let(:new_name) { FFaker::Music.song }
    let(:valid_attributes) { { name: new_name } }

    context 'when the record exists' do
      before { api_put "/songs/#{song_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'PUT /songs/:id/feature' do
    let!(:new_artist) { create(:artist) }
    let(:featured_attributes) {
      {
        featured_artist_id: new_artist.id,
        featured_hero_image_url: "http://testimage.com",
        featured_text: "this is a featured text"
      }
    }

    context 'when the record exists' do
      before { api_put "/songs/#{song_id}/feature", params: featured_attributes }

      it 'should respond with no content' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'should add a new artist to the song' do
        song.reload
        expect(song.artists.count).to eq(2)
        expect(song.artists.last).to eq(new_artist)
        expect(song.artist_songs.last.owner).to eq(false)
      end

      it 'should update the featured attributes' do
        song.reload
        expect(song.featured_hero_image_url).to eq(featured_attributes[:featured_hero_image_url])
        expect(song.featured_text).to eq(featured_attributes[:featured_text])
      end
    end
  end

  describe 'PUT /songs/:id/unfeature' do
    let!(:new_artist) { create(:artist) }
    let(:featured_attributes) {
      {
        featured_artist_id: new_artist.id,
        featured_hero_image_url: "http://testimage.com",
        featured_text: "this is a featured text"
      }
    }

    let(:unfeatured_attributes) {
      {
        unfeatured_artist_id: new_artist.id
      }
    }

    context 'when the record exists' do
      before do
        api_put "/songs/#{song_id}/feature", params: featured_attributes
        api_put "/songs/#{song_id}/unfeature", params: unfeatured_attributes
      end

      it 'should respond with no content' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'should delete the artist from the featured artists collection of the song' do
        song.reload        
        expect(song.artists.count).to eq(1)
        expect(song.artists.first).to eq(artist)
      end

      it 'should unset the featured attributes if there are no remaining featured artists' do
        song.reload
        expect(song.featured).to eq(false)
        expect(song.featured_hero_image_url).to be(nil)
        expect(song.featured_text).to be(nil)
      end
    end
  end

  # Test suite for DELETE /songs/:id
  describe 'DELETE /songs/:id' do
    before { api_delete "/songs/#{song_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
