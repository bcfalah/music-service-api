class CreatePlaylistSongs < ActiveRecord::Migration[5.1]
  def change
    create_table :playlist_songs do |t|
      t.references :playlist, foreign_key: true, index: true
      t.references :song, foreign_key: true, index: true
      t.timestamps
    end
  end
end
