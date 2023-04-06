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

        desc '곡 검색' do
          detail "곡 검색 api. \n
            기본은 정확도순, option으로 recent(최신순) popular(인기순) 지정 가능 "
        end
        params do
          optional :name, type: String
          optional :page, type: Integer
          optional :per_page, type: Integer
          optional :option, type: String, values: %w[recent popular]
        end
        get '', root: :songs do
          case params[:option]
          when 'recent' # 최신순
            Songs.find_song(params[:name]).order(created_at: :desc).page(params[:page]).per(params[:per_page]) 
          when 'popular' # 인기순
            Songs.find_song(params[:name]).order(like: :desc).page(params[:page]).per(params[:per_page]) 
          else # 정확도순
            Songs.find_song(params[:name]).page(params[:page]).per(params[:per_page])
          end
        end
      end
    end
  end
end
