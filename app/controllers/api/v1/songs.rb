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

        desc "정확도순 검색" do
          detail "정확도순 검색 api."
        end
        params do
          optional :name, type: String
          optional :page, type: Integer
          optional :per_page, type: Integer
        end
        get '', root: :songs do # 정확도 순
          Songs.find_song(params[:name]).page(params[:page]).per(params[:per_page])
        end

        desc "최신순 검색" do
          detail "최신순 검색 api."
        end
        params do
          optional :name, type: String
          optional :page, type: Integer
          optional :per_page, type: Integer
        end
        get '/recent', root: :songs do
          return Songs.find_song(params[:name]).order(:created_at).page(params[:page]).per(params[:per_page])
        end

        desc "인기순 검색" do
          detail "인기순 검색 api."
        end
        params do
          optional :name, type: String
          optional :page, type: Integer
          optional :per_page, type: Integer
        end
        get '/popular', root: :songs do
          return Songs.find_song(params[:name]).order(like: :desc).page(params[:page]).per(params[:per_page])
        end
      end
    end
  end
end