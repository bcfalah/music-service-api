class SongSerializer < ActiveModel::Serializer
  attributes :id, :name, :duration, :genre_name, :owner_id, :featured,
    :featured_hero_image_url, :featured_text, :created_at, :updated_at

  belongs_to :owner
  has_many :featured_artists, through: :featured_artist_songs, source: :artist

  def owner_id
    object.owner.id
  end

  def genre_name
    object.genre.name
  end
end
