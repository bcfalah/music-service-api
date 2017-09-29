class CreateAlbumSongs < ActiveRecord::Migration[5.1]
  def change
    create_table :album_songs do |t|
      t.references :album, null: false, foreign_key: true
      t.references :song, null: false, foreign_key: true
      t.timestamps
    end

    add_index :album_songs, [:album_id, :song_id], unique: true
  end
end
