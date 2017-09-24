class CreateSongs < ActiveRecord::Migration[5.1]
  def change
    create_table :songs do |t|
      t.string :name
      t.integer :duration
      t.integer :genre_id
      t.boolean :featured
      t.attachment :featured_hero_image
      t.text :featured_text
      t.timestamps
    end
  end
end
