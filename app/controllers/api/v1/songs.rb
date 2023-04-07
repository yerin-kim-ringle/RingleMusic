
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

      def self.get_query(filter)
        query = {
          fields: %w[name^2 artist_name],
          load: false,
          misspellings: { below: 2 },
          order: get_hash[filter],
          page: 1, per_page: 10
        }
      end

      def self.search_song(name, filter)
        query = get_query(filter)
        !name.nil? ? Song.search(name, query) : Song.search(query)
      end

      def self.search_album(name, filter)
        query = get_query(filter)
        !name.nil? ? Album.search(name, query) : Album.search(query)

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
          optional :filter, type: String, values: %w[recent popular]
        end
        get '', root: :songs do
          songs = Songs.search_song(params[:name], params[:filter])
          songs = Songs.search_album(params[:name], params[:filter]) if songs.count.zero?
          songs
        end
      end
    end
  end
end
