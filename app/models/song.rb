class Song < ApplicationRecord
  belongs_to :genre

  # songs without albums are singles
  has_many :album_songs, dependent: :destroy
  has_many :albums, through: :album_songs

  has_many :playlist_songs, dependent: :destroy
  has_many :playlists, through: :playlist_songs

  # TODO receive genre_name and create genre if it doesn't exist
end
