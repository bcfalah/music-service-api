class Album < ApplicationRecord
  belongs_to :artist
  has_many :album_songs, dependent: :destroy
  has_many :songs, through: :album_songs

  validates_presence_of :name, :artist
  validates_uniqueness_of :artist, scope: :name, case_sensitive: false, message: 'already has an album with this name'
  validates :artwork_url, :format => URI::regexp(%w(http https)),
  if: Proc.new { |album| album.artwork_url.present? }

  def add_songs!(song_ids)
    song_ids.each do |song_id|
      self.album_songs.build(song_id: song_id)
    end
    self.save!
  end

  def delete_songs!(song_ids)
    self.album_songs.where(song_id: song_ids).destroy_all
  end
end
