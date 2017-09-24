require 'rails_helper'

# Test suite for the Todo model
RSpec.describe Genre, type: :model do
  # Association test
  it { should have_many(:songs).dependent(:restrict_with_error) }
  # Validation tests
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).case_insensitive }
end
