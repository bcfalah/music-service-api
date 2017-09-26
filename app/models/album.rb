class Album < ApplicationRecord
  belongs_to :artist
  has_many :album_songs, dependent: :destroy
  has_many :songs, through: :album_songs
  has_attached_file :artwork

  validates_presence_of :name, :artist
  validates_attachment :artwork, content_type: { content_type: /\Aimage\/(jpg|jpeg|pjpeg|png|x-png|gif)\z/ }
end
