class Api::V1::ArtistsController < ApplicationController
  before_action :set_artist, only: [:show, :update, :destroy]

  # GET /api/v1/artists
  def index
    @artists = Artist.all
    json_response @artists
  end

  # GET /api/v1/artists/1
  def show
    json_response @artist
  end

  # POST /api/v1/artists
  def create
    @artist = Artist.create!(artist_params)
    json_response @artist, :created
  end

  # PATCH/PUT /api/v1/artists/1
  def update
    @artist.update!(artist_params)
    head :no_content
  end

  # DELETE /api/v1/artists/1
  def destroy
    @artist.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_artist
    @artist = Artist.find(params[:id])
  end

  def artist_params
    params.permit(:name, :biography)
  end
end
