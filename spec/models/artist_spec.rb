require 'rails_helper'

# Test suite for the Todo model
RSpec.describe Artist, type: :model do
  # Association test
  it { should have_many(:artist_songs).dependent(:destroy) }
  it { should have_many(:songs).through(:artist_songs) }
  it { should have_many(:albums).dependent(:restrict_with_error) }
  # Validation tests
  it { should validate_presence_of(:name) }
end
