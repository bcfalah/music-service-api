class ArtistSong < ApplicationRecord
  belongs_to :artist
  belongs_to :song

  validates_presence_of :artist, :song
  validates_uniqueness_of :artist, scope: :song, message: 'already has this song'
end
