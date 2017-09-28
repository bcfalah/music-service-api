class Api::V1::SongsController < ApplicationController
  before_action :set_song, only: [:show, :update, :feature, :unfeature, :destroy]

  swagger_controller :songs, "Song Management"

  swagger_api :index do
    summary "Fetches all songs ordered by Id"
    response :ok
  end

  def index
    @songs = Song.order(:id).all
    json_response @songs
  end

  swagger_api :show do
    summary "Fetches a single Song"
    param :path, :id, :integer, :required, "Song Id"
    response :ok
    response :not_found
    response :unprocessable_entity
  end

  def show
    json_response @song
  end

  swagger_api :create do
    summary "Creates a song"
    param :form, "name", :string, :required, "Name of the song"
    param :form, "duration", :integer, :required, "Duration of the song"
    param :form, "genre_name", :string, :required, "Name of the song genre (it will be created if doesn't exist)"
    param :form, "owner_id", :integer, :required, "Id of the song's owner (must be an existing artist Id)"
    response :created
    response :not_found
    response :unprocessable_entity
  end

  def create
    @song = Song.create!(songs_params)
    json_response @song, :created
  end

  swagger_api :update do
    summary "Updates an existing Song"
    param :path, :id, :integer, :required, "Song Id"
    param :form, "name", :string, :optional, "Name of the song"
    param :form, "duration", :integer, :optional, "Duration of the song"
    param :form, "genre_name", :string, :optional, "Name of the song genre (it will be created if doesn't exist)"
    param :form, "owner_id", :integer, :optional, "Id of the song's owner (must be an existing artist Id)"
    response :no_content
    response :not_found
    response :unprocessable_entity
  end

  def update
    @song.update!(songs_params)
    head :no_content
  end

  swagger_api :destroy do
    summary "Deletes an existing Song item"
    param :path, :id, :integer, :required, "Song Id"
    response :no_content, "Deleted"
    response :not_found
    response :unprocessable_entity
  end

  def destroy
    @song.destroy!
    head :no_content
  end

  swagger_api :feature do
    summary "Makes a song featured, adding a new artist to it and setting optional featured attributes"
    param :path, :id, :integer, :required, "Song Id"
    param :form, "featured_artist_id", :integer, :optional, "Id of the featured artist, only required if the song already hasn't at least one"
    param :form, "featured_hero_image_url", :string, :optional, "URL of the featured image"
    param :form, "featured_text", :string, :optional, "Extra text to describe or promote the featured song"
    response :no_content
    response :not_found
    response :unprocessable_entity
  end

  def feature
    @song.feature!(featured_params)
    head :no_content
  end

  swagger_api :unfeature do
    summary "Deletes an artist from the featured collection of the song and unsets its featured attributes if no remaining featured artist"
    param :path, :id, :integer, :required, "Song Id"
    param :form, "unfeatured_artist_id", :integer, :required, "Id of the featured artist to delete from the collection of featured artists"
    response :no_content
    response :not_found
    response :unprocessable_entity
  end

  def unfeature
    @song.unfeature!(unfeatured_params)
    head :no_content
  end

  private

  def set_song
    @song = Song.find(params[:id])
  end

  def songs_params
    params.permit(:name, :duration, :genre_name, :owner_id)
  end

  def featured_params
    params.permit(:featured_artist_id, :featured_hero_image_url, :featured_text)
  end

  def unfeatured_params
    params.permit(:unfeatured_artist_id)
  end
end
