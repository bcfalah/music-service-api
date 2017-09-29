class AlbumCompleteSerializer < ActiveModel::Serializer
  attributes :id, :name, :artist_id, :artwork_url, :created_at, :updated_at

  belongs_to :artist
  has_many :songs
end
