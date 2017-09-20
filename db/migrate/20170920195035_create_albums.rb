class CreateAlbums < ActiveRecord::Migration[5.1]
  def change
    create_table :albums do |t|
      t.string :name
      t.integer :artist_id, foreign_key: true, index: true
      t.attachment :artwork
      t.timestamps
    end
  end
end
