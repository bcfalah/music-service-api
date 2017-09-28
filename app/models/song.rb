class Song < ApplicationRecord
  belongs_to :genre

  has_many :artist_songs, dependent: :destroy
  has_many :artists, through: :artist_songs

  has_many :album_songs, dependent: :destroy
  has_many :albums, through: :album_songs

  has_many :playlist_songs, dependent: :destroy
  has_many :playlists, through: :playlist_songs

  attr_accessor :genre_name, :owner_id

  validates_presence_of :name, :duration
  validates_presence_of :genre_name, :owner_id, on: :create
  validate :owner_exists

  before_validation :assign_genre
  after_save :assign_owner

  def owner
    artist_songs.where(owner: true).first
  end

  private

  def owner_exists
    if owner_id.present? && Artist.where(id: owner_id).first.blank?
      self.errors.add(:base, "There's not an artist with this owner_id")
    end
  end

  def assign_owner
    # in case of an update of the owner_id, the user wants to change the owner,
    # so we delete the relation with the current owner
    if owner_id.present? && owner.present? && owner.artist_id != owner_id
      owner.destroy
      self.artist_songs << ArtistSong.new(artist_id: owner_ids, owner: true)
    end
  end

  def assign_genre
    self.genre = Genre.find_or_initialize_by(name: genre_name) if genre_name.present?
  end
end
