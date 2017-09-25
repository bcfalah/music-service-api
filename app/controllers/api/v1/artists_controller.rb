class Api::V1::ArtistsController < ApplicationController
  before_action :set_artist, only: [:show, :update, :destroy]

  swagger_controller :artists, "Artist Management"

  swagger_api :index do
    summary "Fetches all artists"
    response :ok
  end

  def index
    @artists = Artist.all
    json_response @artists
  end

  swagger_api :show do
    summary "Fetches a single Artist"
    param :path, :id, :integer, :required, "Artist Id"
    response :ok, "Success", :Artist
    response :not_found
    response :unprocessable_entity
  end

  def show
    json_response @artist
  end

  swagger_api :create do
    summary "Creates an artist"
    param :form, "name", :string, :required, "Name of the artist"
    param :form, "biography", :string, :optional, "Biography of the artist"
    response :created
    response :not_found
    response :unprocessable_entity
  end

  def create
    @artist = Artist.create!(artist_params)
    json_response @artist, :created
  end

  swagger_api :update do
    summary "Updates an existing User"
    param :path, :id, :integer, :required, "Artist Id"
    param :form, "name", :string, :required, "Name of the artist"
    param :form, "biography", :string, :optional, "Biography of the artist"
    response :no_content
    response :not_found
    response :unprocessable_entity
  end

  def update
    @artist.update!(artist_params)
    head :no_content
  end

  swagger_api :destroy do
    summary "Deletes an existing User item"
    param :path, :id, :integer, :required, "Artist Id"
    response :no_content
    response :not_found
    response :unprocessable_entity
  end

  def destroy
    @artist.destroy
    head :no_content
  end

  private

  def set_artist
    @artist = Artist.find(params[:id])
  end

  def artist_params
    params.permit(:name, :biography)
  end
end
