class Playlist < ApplicationRecord
  has_many :playlist_songs, dependent: :destroy
  has_many :songs, through: :playlist_songs

  validates_presence_of :name

  def add_song!(song_id)
    self.playlist_songs.create!(song_id: song_id)
  end

  def delete_song!(song_id)
    self.playlist_songs.where(song_id: song_id).destroy_all
  end
end
