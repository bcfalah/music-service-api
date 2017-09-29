class AlbumSong < ApplicationRecord
  belongs_to :album
  belongs_to :song

  validates_presence_of :album, :song
  validates_uniqueness_of :album, scope: :song, message: 'already has this song'
end
