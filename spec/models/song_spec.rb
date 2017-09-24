require 'rails_helper'

# Test suite for the Todo model
RSpec.describe Song, type: :model do
  # Association test
  # ensure Todo model has a 1:m relationship with the Item model
  it { should have_many(:album_songs).dependent(:destroy) }
  it { should have_many(:albums).through(:album_songs) }
  # Validation tests
  # ensure columns title and created_by are present before saving
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:duration) }
  it { should validate_presence_of(:genre_name) }

  describe 'Genre manipulation' do
    context "when it doesn't exist" do
      let(:genre_name) { FFaker::Music.genre }
      let(:song) { FactoryGirl.build :song, genre_name: genre_name }

      it "should create a new genre" do
        expect { song.save }.to change { Genre.count }.by(1)
      end

      it "the new genre should match with genre_name" do
        song.save
        expect(song.genre.name).to eq genre_name
      end
    end

    context "when it already exists" do
      let(:genre_name) { FFaker::Music.genre }
      let!(:first_song) { FactoryGirl.create :song, genre_name: genre_name }
      let(:second_song) { FactoryGirl.build :song, genre_name: genre_name }

      it "should not create a new genre" do
        expect { second_song.save }.to_not change { Genre.count }
      end

      it "both songs should have the same genre record" do
        second_song.save
        expect(second_song.genre).to eq first_song.genre
      end
    end
  end
end
