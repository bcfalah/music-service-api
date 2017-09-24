class Artist < ApplicationRecord
  has_many :albums, dependent: :restrict_with_error

  def full_destroy
    # TODO destroy with albums
  end
end
