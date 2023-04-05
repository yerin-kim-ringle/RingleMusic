class AddReference < ActiveRecord::Migration[6.1]
  def change
    add_reference :songs, :album
    add_reference :playlistinfos, :song
  end
end
