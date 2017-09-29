class Song < ApplicationRecord
  belongs_to :genre

  has_many :artist_songs, dependent: :destroy
  has_many :artists, through: :artist_songs
  has_many :featured_artist_songs, -> { where owner: false }, class_name: 'ArtistSong'
  has_many :featured_artists, through: :featured_artist_songs, source: :artist

  has_many :album_songs, dependent: :destroy
  has_many :albums, through: :album_songs

  has_many :playlist_songs, dependent: :destroy
  has_many :playlists, through: :playlist_songs

  attr_accessor :genre_name, :owner_id, :featured_artist_id

  validates_presence_of :name, :duration
  validates :duration, :numericality => { only_integer: true, greater_than: 0 }
  validates_presence_of :genre_name, :owner_id, on: :create
  validate :owner_exists?
  validate :featured_artist_exists, on: :feature

  before_validation :assign_genre, :assign_owner

  def owner_relation
    artist_songs.where(owner: true).first
  end

  def owner
    artist_songs.where(owner: true).first.artist
  end

  def feature!(featured_params)
    self.attributes = featured_params.merge(featured: true)
    if featured_artist_id && !already_featured_by?(featured_artist_id)
      self.artist_songs.build(artist_id: featured_artist_id)
    end
    save!(context: :feature)
  end

  def unfeature!(unfeatured_params)
    artist_id = unfeatured_params[:unfeatured_artist_id]
    if artist_id && already_featured_by?(artist_id)
      self.artist_ids = self.artist_ids - [artist_id.to_i]
      if featured_artists.empty?
        self.featured = false
        self.featured_hero_image_url = nil
        self.featured_text = nil
      end
    end
    save!
  end

  private

  def owner_exists?
    if owner_id.present? && Artist.where(id: owner_id).first.blank?
      self.errors.add(:owner_id, "There's not an artist with this owner_id")
    end
  end

  def assign_genre
    self.genre = Genre.find_or_initialize_by(name: genre_name) if genre_name.present?
  end

  def assign_owner
    # in case of an update of the owner_id, the user wants to change the owner,
    # so we delete the relation with the current owner
    if owner_id.present?
      self.artist_song_ids = self.artist_song_ids - [owner_relation.id] if owner_relation.present?
      self.artist_songs.build(artist_id: owner_id, owner: true)
    end
  end

  def featured_artist_exists
    if self.featured_artists.count == 0 && Artist.where(id: featured_artist_id).first.blank?
      self.errors.add(:featured_artist_id, "There's not an artist with this featured_artist_id")
    end
  end

  def already_featured_by?(featured_artist_id)
    featured_artists.pluck(:id).include?(featured_artist_id.to_i)
  end
end
