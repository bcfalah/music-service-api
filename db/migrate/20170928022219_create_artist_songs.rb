class CreateArtistSongs < ActiveRecord::Migration[5.1]
  def change
    create_table :artist_songs do |t|
      t.references :artist, null: false, foreign_key: true
      t.references :song, null: false, foreign_key: true
      t.boolean :owner, default: false
      t.timestamps
    end

    add_index :artist_songs, [:artist_id, :song_id], unique: true
  end
end
