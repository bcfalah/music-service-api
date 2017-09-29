class Artist < ApplicationRecord
  has_many :artist_songs, dependent: :destroy
  has_many :songs, through: :artist_songs

  has_many :albums, dependent: :restrict_with_error

  validates_presence_of :name
  validates_uniqueness_of :name, case_sensitive: false
end
