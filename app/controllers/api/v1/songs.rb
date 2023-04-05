module API
  module V1
    class Songs < Grape::API
      version 'v1', using: :path
      format :json
      prefix :api

      def self.find_song(name)
        song =  Song.where('name LIKE ?',"%#{name}%") # 제목으로
        song = Song.where('artist_name LIKE ?',"%#{name}%") unless song.exists? # 아티스트명으로
        unless song.exists? # 앨범명으로
          album = Album.find_by('name LIKE ?',"%#{name}%")
          song = Song.where(album_id: album.id) if album
        end
        song
      end

      resource :songs do
        desc 'Search Songs'
        params do
          optional :name, type: String
        end
        get '', root: :songs do # 정확도 순
          Songs.find_song(params[:name])
        end


        params do
          optional :name, type: String
        end
        get '/recent', root: :songs do # 최신순
          return Songs.find_song(params[:name]).order(:created_at)
        end


        params do
          optional :name, type: String
        end
        get '/popular', root: :songs do # 인기순
          return Songs.find_song(params[:name]).order(like: :desc)
        end
      end
    end
  end
end