class CreatePlaylists < ActiveRecord::Migration[6.1]
  def change
    create_table :playlists do |t|
      t.string :title
      t.integer :p_type
      t.integer :ref_id #그룹 혹은 유저 아이디.
      t.timestamps
    end
  end
end
