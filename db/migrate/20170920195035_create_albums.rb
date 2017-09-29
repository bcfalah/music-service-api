class CreateAlbums < ActiveRecord::Migration[5.1]
  def change
    create_table :albums do |t|
      t.string :name, null: false
      t.integer :artist_id, foreign_key: true, index: true
      t.string :artwork_url
      t.timestamps
    end

    add_index :albums, [:artist_id, :name], unique: true
  end
end
