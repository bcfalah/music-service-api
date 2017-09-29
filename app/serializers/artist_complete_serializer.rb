class ArtistCompleteSerializer < ActiveModel::Serializer
  attributes :id, :name, :biography, :created_at, :updated_at
  has_many :albums
  has_many :songs
end
