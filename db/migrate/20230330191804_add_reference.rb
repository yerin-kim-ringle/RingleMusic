class AddReference < ActiveRecord::Migration[6.1]
  def change
    add_reference :songs, :album
    add_reference :groups, :user
    add_reference :users, :group
    add_reference :playlistinfos, :song
    add_reference :songs, :playlistinfo
  end
end
