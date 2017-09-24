class Genre < ApplicationRecord
  has_many :songs, dependent: :restrict_with_error

  validates_presence_of :name
  validates :name, uniqueness: { case_sensitive: false }
end
