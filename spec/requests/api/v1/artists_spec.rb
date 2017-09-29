require 'rails_helper'

RSpec.describe 'Api::V1::Artists', type: :request do
  # initialize test data
  let!(:artists) { create_list(:artist, 10) }
  let(:artist_id) { artists.first.id }

  # Test suite for GET /artists
  describe 'GET /artists' do
    before { api_get '/artists' }

    it 'returns artists' do
      expect(json_response).not_to be_empty
      expect(json_response.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /artists/:id
  describe 'GET /artists/:id' do
    before { api_get "/artists/#{artist_id}" }

    context 'when the record exists' do
      it 'returns the artist' do
        expect(json_response).not_to be_empty
        expect(json_response['id']).to eq(artist_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:artist_id) { "not_exists" }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Artist/)
      end
    end
  end

  # Test suite for POST /artists
  describe 'POST /artists' do
    let(:artist_name) { 'The Beatles' }
    let(:valid_attributes) { { name: artist_name } }

    context 'when the request is valid' do
      before { api_post '/artists', params: valid_attributes }

      it 'creates an artist' do
        expect(json_response['name']).to eq(artist_name)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { api_post '/artists', params: {  } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  # Test suite for PUT /artists/:id
  describe 'PUT /artists/:id' do
    let(:new_name) { FFaker::Music.artist }
    let(:valid_attributes) { { name: new_name } }

    context 'when the record exists' do
      before { api_put "/artists/#{artist_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /artists/:id
  describe 'DELETE /artists/:id' do
    before { api_delete "/artists/#{artist_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
