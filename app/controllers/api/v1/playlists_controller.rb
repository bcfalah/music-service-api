class Api::V1::PlaylistsController < ApplicationController
  before_action :set_playlist, only: [:show, :update, :add_songs, :delete_songs, :destroy]

  swagger_controller :playlist, "Playlist Management"

  swagger_api :index do
    summary "Fetches all playlist ordered by Id"
    response :ok
  end

  def index
    @playlist = Playlist.order(:id).all
    json_response @playlist
  end

  swagger_api :show do
    summary "Fetches a single Playlist"
    param :path, :id, :integer, :required, "Playlist Id"
    response :ok
    response :not_found
    response :unprocessable_entity
  end

  def show
    json_response @playlist
  end

  swagger_api :create do
    summary "Creates an playlist"
    param :form, "name", :string, :required, "Name of the playlist"
    response :created
    response :not_found
    response :unprocessable_entity
  end

  def create
    @playlist = Playlist.create!(playlist_params)
    json_response @playlist, :created
  end

  swagger_api :update do
    summary "Updates an existing Playlist"
    param :path, :id, :integer, :required, "Playlist Id"
    param :form, "name", :string, :optional, "Name of the playlist"
    response :no_content
    response :not_found
    response :unprocessable_entity
  end

  def update
    @playlist.update!(playlist_params)
    head :no_content
  end

  swagger_api :add_songs do
    summary "Adds one or many songs to a playlist"
    param :path, :id, :integer, :required, "Playlist Id"
    param :form, "song_ids", :string, :required, "Comma separated Ids of the songs to add to the playlist"
    response :no_content
    response :not_found
    response :unprocessable_entity
  end

  def add_songs
    @playlist.add_songs!(add_songs_params[:song_ids].split(','))
    head :no_content
  end

  swagger_api :delete_songs do
    summary "Deletes one or many songs from the playlist"
    param :path, :id, :integer, :required, "Playlist Id"
    param :form, "song_ids", :string, :required, "Comma separated Ids of the songs to delete from the playlist"
    response :no_content
    response :not_found
    response :unprocessable_entity
  end

  def delete_songs
    @playlist.delete_songs!(delete_songs_params[:song_ids].split(','))
    head :no_content
  end

  swagger_api :destroy do
    summary "Deletes an existing Playlist"
    param :path, :id, :integer, :required, "Playlist Id"
    response :no_content, "Deleted"
    response :not_found
    response :unprocessable_entity
  end

  def destroy
    @playlist.destroy
    head :no_content
  end

  private

  def set_playlist
    @playlist = Playlist.find(params[:id])
  end

  def playlist_params
    params.permit(:name)
  end

  def add_songs_params
    params.permit(:song_ids)
  end

  def delete_songs_params
    params.permit(:song_ids)
  end
end
