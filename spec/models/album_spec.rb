require 'rails_helper'

# Test suite for the Todo model
RSpec.describe Album, type: :model do
  # Association test
  it { should belong_to(:artist) }
  it { should have_many(:album_songs).dependent(:destroy) }
  it { should have_many(:songs).through(:album_songs) }
  # Validation tests
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:artist) }
end
