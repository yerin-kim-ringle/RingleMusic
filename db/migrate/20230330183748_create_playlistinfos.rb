class CreatePlaylistinfos < ActiveRecord::Migration[6.1]
  def change
    create_table :playlistinfos do |t|
      t.integer :playlist_id
      t.timestamps
    end
  end
end
