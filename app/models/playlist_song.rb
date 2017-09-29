class PlaylistSong < ApplicationRecord
  belongs_to :playlist
  belongs_to :song

  validates_presence_of :playlist, :song
  validates_uniqueness_of :playlist, scope: :song, message: 'already has this song'
end
