
module API
  module V1
    class Songs < Grape::API
      version 'v1', using: :path
      format :json
      prefix :api

      def self.get_hash
        hash = {
          nil => nil,
          'popular' => { like: :desc },
          'recent' => { created_at: :desc }
        }
      end

      def self.get_query(params)
        query = {
          fields: %w[name^2 artist_name],
          load: false,
          misspellings: { below: 2 },
          order: get_hash[params[:filter]],
          page: params[:page], per_page: params[:per_page]
        }
      end

      def self.search_song(params)
        query = get_query(params)
        !params[:name].nil? ? Song.search(params[:name], query) : Song.search(query)
      end

      def self.search_album(params)
        query = get_query(params)
        !params[:name].nil? ? Album.search(params[:name], query) : Album.search(query)

      end
      resource :songs do
        desc 'Search Songs'
        desc '곡 검색' do
          detail "곡 검색 api. \n
            기본은 정확도순, filter로 recent(최신순) popular(인기순) 지정 가능 "
        end
        params do
          optional :name, type: String
          optional :page, type: Integer, default: 0
          optional :per_page, type: Integer, default: 10
          optional :filter, type: String, values: %w[recent popular]
        end
        get '', root: :songs do
          songs = Songs.search_song(params)
          songs = Songs.search_album(params) if songs.count.zero?

          Rails.logger.info("times took (in milliseconds): "+ songs.took.to_s)
          songs.response
        end
      end
    end
  end
end
