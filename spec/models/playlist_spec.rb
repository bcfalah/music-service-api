require 'rails_helper'

# Test suite for the Todo model
RSpec.describe Playlist, type: :model do
  # Association test
  it { should have_many(:playlist_songs).dependent(:destroy) }
  it { should have_many(:songs).through(:playlist_songs) }
  # Validation tests
  it { should validate_presence_of(:name) }
end
