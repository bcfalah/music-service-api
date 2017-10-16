class Api::V1::AlbumsController < ApplicationController
  before_action :set_album, only: [:show, :update, :add_songs, :delete_songs, :destroy]

  swagger_controller :albums, "Album Management"

  swagger_api :index do
    summary "Fetches all albums ordered by Id"
    response :ok
  end

  def index
    @albums = Album.order(:id).all
    json_response @albums
  end

  swagger_api :show do
    summary "Fetches a single Album"
    param :path, :id, :integer, :required, "Album Id"
    response :ok
    response :not_found
    response :unprocessable_entity
  end

  def show
    json_response @album, :ok, serializer: AlbumCompleteSerializer
  end

  swagger_api :create do
    summary "Creates an album"
    param :form, "name", :string, :required, "Name of the album"
    param :form, "artist_id", :integer, :required, "Artist ID of the album"
    param :form, "artwork_url", :string, :optional, "URL of the album's artwork"
    response :created
    response :not_found
    response :unprocessable_entity
  end

  def create
    @album = Album.create!(album_params)
    json_response @album, :created, serializer: AlbumCompleteSerializer
  end

  swagger_api :update do
    summary "Updates an existing Album"
    param :path, :id, :integer, :required, "Album Id"
    param :form, "name", :string, :optional, "Name of the album"
    param :form, "artist_id", :integer, :optional, "Artist ID of the album"
    param :form, "artwork_url", :string, :optional, "URL of the album's artwork"
    response :no_content
    response :not_found
    response :unprocessable_entity
  end

  def update
    @album.update!(album_params)
    head :no_content
  end

  swagger_api :add_songs do
    summary "Adds one or many songs to an album"
    param :path, :id, :integer, :required, "Album Id"
    param :form, "song_ids", :string, :required, "Comma separated Ids of the songs to add to the album"
    response :no_content
    response :not_found
    response :unprocessable_entity
  end

  def add_songs
    @album.add_songs!(add_songs_params[:song_ids].split(','))
    head :no_content
  end

  swagger_api :delete_songs do
    summary "Deletes one or many songs from the album"
    param :path, :id, :integer, :required, "Album Id"
    param :form, "song_ids", :integer, :required, "Comma separated Ids of the songs to delete from the album"
    response :no_content
    response :not_found
    response :unprocessable_entity
  end

  def delete_songs
    @album.delete_songs!(delete_songs_params[:song_ids].split(','))
    head :no_content
  end

  swagger_api :destroy do
    summary "Deletes an existing Album"
    param :path, :id, :integer, :required, "Album Id"
    response :no_content, "Deleted"
    response :not_found
    response :unprocessable_entity
  end

  def destroy
    @album.destroy
    head :no_content
  end

  private

  def set_album
    @album = Album.find(params[:id])
  end

  def album_params
    params.permit(:name, :artist_id, :artwork_url)
  end

  def add_songs_params
    params.permit(:song_ids)
  end

  def delete_songs_params
    params.permit(:song_ids)
  end
end
