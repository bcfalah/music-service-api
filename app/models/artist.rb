class Artist < ApplicationRecord
  has_many :albums, dependent: :restrict_with_error

  validates_presence_of :name

  def full_destroy
    # TODO destroy with albums
  end
end
