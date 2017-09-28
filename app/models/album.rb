class Album < ApplicationRecord
  belongs_to :artist
  has_many :album_songs, dependent: :destroy
  has_many :songs, through: :album_songs

  validates_presence_of :name, :artist
  validates_uniqueness_of :artist, scope: :name, case_sensitive: false, message: 'already has an album with this name'

  def add_song!(song_id)
    self.album_songs.create!(song_id: song_id)
  end

  def delete_song!(song_id)
    self.album_songs.where(song_id: song_id).destroy_all
  end
end
