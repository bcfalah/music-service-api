class Api::V1::ArtistsController < Api::V1::ApiController
  before_action :set_artist, only: [:show, :update, :destroy]

  swagger_controller :artists, "Artist Management"

  def index
    @artists = Artist.all
    json_response @artists
  end

  def show
    json_response @artist
  end

  swagger_api :create do
    summary "To create an artist"
    param :form, "name", :string, :required, "Name of the artist"
    param :form, "biography", :string, :optional, "Biography of the artist"
    response :success
    response :unprocessable_entity
  end

  def create
    @artist = Artist.create!(artist_params)
    json_response @artist, :created
  end

  def update
    @artist.update!(artist_params)
    head :no_content
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
