class Playlist < ApplicationRecord
  has_many :playlist_songs, dependent: :destroy
  has_many :songs, through: :playlist_songs

  validates_presence_of :name

  def add_songs!(song_ids)
    song_ids.each do |song_id|
      self.playlist_songs.build(song_id: song_id)
    end
    self.save!
  end

  def delete_songs!(song_ids)
    self.playlist_songs.where(song_id: song_ids).destroy_all
  end
end
