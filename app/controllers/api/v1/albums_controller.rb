class Api::V1::AlbumsController < ApplicationController
  before_action :set_artist, only: [:show, :update, :destroy]

  swagger_controller :albums, "Album Management"

  swagger_api :index do
    summary "Fetches all albums"
    response :ok
  end

  def index
    @albums = Album.all
    json_response @albums
  end

  swagger_api :show do
    summary "Fetches a single Album"
    param :path, :id, :integer, :required, "Album Id"
    response :ok, "Success", :Album
    response :not_found
    response :unprocessable_entity
  end

  def show
    json_response @album
  end

  swagger_api :create do
    summary "Creates an album"
    param :form, "name", :string, :required, "Name of the album"
    param :form, "artist_id", :integer, :required, "Artist ID of the album"
    response :created
    response :not_found
    response :unprocessable_entity
  end

  def create
    @album = Album.create!(album_params)
    json_response @album, :created
  end

  swagger_api :update do
    summary "Updates an existing Album"
    param :path, :id, :integer, :required, "Album Id"
    param :form, "name", :string, :required, "Name of the album"
    param :form, "artist_id", :integer, :required, "Artist ID of the album"
    response :no_content
    response :not_found
    response :unprocessable_entity
  end

  def update
    @album.update!(album_params)
    head :no_content
  end

  swagger_api :destroy do
    summary "Deletes an existing Album item"
    param :path, :id, :integer, :required, "Album Id"
    response :no_content
    response :not_found
    response :unprocessable_entity
  end

  def destroy
    @album.destroy
    head :no_content
  end

  private

  def set_artist
    @album = Album.find(params[:id])
  end

  def album_params
    params.permit(:name, :artist_id, :artwork)
  end
end
