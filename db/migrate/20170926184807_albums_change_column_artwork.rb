class AlbumsChangeColumnArtwork < ActiveRecord::Migration[5.1]
  def change
    remove_column :albums, :artwork_file_name
    remove_column :albums, :artwork_content_type
    remove_column :albums, :artwork_file_size
    remove_column :albums, :artwork_updated_at
    add_column :albums, :artwork_url, :string
  end
end
