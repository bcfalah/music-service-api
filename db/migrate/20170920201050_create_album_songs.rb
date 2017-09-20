class CreateAlbumSongs < ActiveRecord::Migration[5.1]
  def change
    create_table :album_songs do |t|
      t.references :album, foreign_key: true, index: true
      t.references :song, foreign_key: true, index: true
      t.timestamps
    end
  end
end
