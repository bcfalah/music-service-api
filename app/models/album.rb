class Album < ApplicationRecord
  belongs_to :artist
  has_many :album_songs, dependent: :destroy
  has_many :songs, through: :album_songs

  validates_presence_of :name, :artist
  validates_uniqueness_of :artist, scope: :name, case_sensitive: false, message: 'already has an album with this name'
end
