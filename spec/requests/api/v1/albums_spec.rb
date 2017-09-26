require 'rails_helper'

RSpec.describe 'Api::V1::Albums', type: :request do
  let!(:artist) { create(:artist) }
  let!(:albums) { create_list(:album, 10, artist: artist) }
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
      let(:album_id) { 100 }

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

  # Test suite for DELETE /albums/:id
  describe 'DELETE /albums/:id' do
    before { api_delete "/albums/#{album_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
