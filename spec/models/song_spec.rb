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
  it { should validate_presence_of(:genre_name).on(:create) }
  it { should validate_presence_of(:owner_id).on(:create) }

  let!(:artist) { create(:artist) }

  describe 'Owner' do
    context "on create" do
      context "when it doesn't exist" do
        let(:song) { build :song, owner_id: "not_exists" }

        it "should not be valid" do
          song.save
          expect(song.valid?).to eq false
        end

        it "should validate owner_id" do
          song.save
          expect(song.errors[:owner_id]).to_not be nil
        end
      end

      context "when it already exists" do
        let(:song) { build :song, owner_id: artist.id }

        it "should be valid" do
          song.save
          expect(song.valid?).to eq true
        end

        it "should create a new ArtistSong" do
          expect { song.save }.to change { ArtistSong.count }.by(1)
        end

        it "its owner should match with artist" do
          song.save
          expect(song.owner).to eq artist
        end
      end
    end

    context "on onwner_id update" do
      let!(:song) { create :song, owner_id: artist.id }

      context "when it doesn't exist" do
        it "should not be valid" do
          song.owner_id = "not_exists"
          song.save
          expect(song.valid?).to eq false
        end

        it "should validate owner_id" do
          song.owner_id = "not_exists"
          song.save
          expect(song.errors[:owner_id]).to_not be nil
        end
      end

      context "when it already exists" do
        context "when it is the same owner" do
          it "should be valid" do
            song.owner_id = artist.id
            song.save
            expect(song.valid?).to eq true
          end

          it "should not create a new ArtistSong" do
            expect { song.update(owner_id: artist.id) }.to_not change { ArtistSong.count }
          end

          it "its owner should match with artist" do
            song.update(owner_id: artist.id)
            expect(song.owner).to eq artist
          end
        end

        context "when it is a different owner" do
          let!(:new_owner) { create :artist }

          it "should be valid" do
            song.owner_id = new_owner.id
            song.save
            expect(song.valid?).to eq true
          end

          it "should delete the previous ArtistSong and create a new one" do
            song.owner_id = new_owner.id
            song.save
            expect(song.artists.count).to eq 1
          end

          it "its owner should match with artist" do
            song.update(owner_id: new_owner.id)
            expect(song.owner).to eq new_owner
          end
        end
      end
    end
  end

  describe 'Genre manipulation' do
    let(:genre_name) { FFaker::Music.genre }
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
