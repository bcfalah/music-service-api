class Song < ApplicationRecord
  belongs_to :genre
  # songs without albums are singles
  has_many :album_songs, dependent: :destroy
  has_many :albums, through: :album_songs

  has_many :playlist_songs, dependent: :destroy
  has_many :playlists, through: :playlist_songs

  validates_presence_of :name, :duration, :genre_name

  attr_accessor :genre_name

  before_validation :add_genre

  def single?
    albums.empty?
  end

  private

  def add_genre
    self.genre = Genre.find_or_initialize_by(name: genre_name)
  end
end
