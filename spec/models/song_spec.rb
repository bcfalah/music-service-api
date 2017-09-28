require 'rails_helper'

# Test suite for the Todo model
RSpec.describe Song, type: :model do
  # Association test
  it { should have_many(:artist_songs).dependent(:destroy) }
  it { should have_many(:artists).through(:artist_songs) }
  it { should have_many(:album_songs).dependent(:destroy) }
  it { should have_many(:albums).through(:album_songs) }
  it { should have_many(:playlist_songs).dependent(:destroy) }
  it { should have_many(:playlists).through(:playlist_songs) }

  # Validation tests
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:duration) }
  it { should validate_presence_of(:genre_name) }

  let(:genre_name) { FFaker::Music.genre }
  let!(:artist) { create(:artist) }

  describe 'Owner' do
    context "on create" do
      context "when it doesn't exist" do
        let(:song) { build :song, genre_name: genre_name, owner_id: 100 }

        it "should not be valid" do
          song.save
          expect(song.valid?).to eq false
        end

        it "should validate owner_id" do
          #song.save
          #expect(song.valid?).to eq false
        end
      end
    end

    context "when it already exists" do

    end
  end

  describe 'Genre manipulation' do
    context "when it doesn't exist" do
      let(:song) { build :song, genre_name: genre_name, owner_id: artist.id }

      it "should create a new genre" do
        expect { song.save }.to change { Genre.count }.by(1)
      end

      it "the new genre should match with genre_name" do
        song.save
        expect(song.genre.name).to eq genre_name
      end
    end

    context "when it already exists" do
      let!(:first_song) { create :song, genre_name: genre_name, owner_id: artist.id }
      let(:second_song) { build :song, genre_name: genre_name, owner_id: artist.id }

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
