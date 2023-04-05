# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
## Make Users
#
require 'faker'
require 'CSV'
user_count = 100
music_count = 1500
group_count = 30
playlist_count = 100
users_per_group = (3..20).to_a
musics_per_playlist = (30..100).to_a
likes_per_user = (0..50).to_a
'
puts "Making #{user_count} Users..."
1.upto(user_count) { |i|
  User.create(name: Faker::Name.name, email: "user_#{i}@gmail.com", password: "123456")
}'

## Make Musics
puts "Making #{music_count} Songs..."
sample_music_file =  Rails.root.join("config", "musics", "music.csv")
music_csvs = CSV.parse(File.read(sample_music_file), :headers=>true)
music_csv_sampled = music_csvs[0..(music_count-1)]
music_csv_sampled.map { |music_csv|
  music_csv = music_csv.to_hash
  Song.create(name: music_csv["title"], artist_name: music_csv["artist_name"], album_id: 1,like:rand(10))
}

## Make Albums
puts "Making #{music_count} Albums..."
sample_music_file =  Rails.root.join("config", "musics", "music.csv")
music_csvs = CSV.parse(File.read(sample_music_file), :headers=>true)
music_csv_sampled = music_csvs[0..(music_count-1)]
music_csv_sampled.map { |music_csv|
  music_csv = music_csv.to_hash
  Album.create(name: music_csv["album_name"])
}

## Make Groups
puts "Making #{group_count} Groups..."
group_count.times {
  Group.create!(name: "#{Faker::FunnyName.name} Group")
}

## Make Playlist
puts "Making #{playlist_count} Playlists..."
group_count.times {
  Playlist.create!(title: "#{Faker::FunnyName.name} Playlist")
}

## Make UserGroups
puts "Making UserGroups"
1.upto(user_count) { |i|
  UserGroup.create(user_id:i,group_id:i)
}

## Make Playlistinfo
puts "Making Playlistinfo."
music_count.times {
  Playlistinfo.create!(playlist_id:rand(playlist_count),song_id:rand(music_count))
}
