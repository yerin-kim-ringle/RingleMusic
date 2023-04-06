module API
  module V1
    class Playlists < Grape::API
      version 'v1', using: :path
      format :json
      prefix :api

      resource :playlists do
        desc 'Manage Songs'

        desc "유저/그룹 재생목록 추가" do
          detail "유저/그룹 재생목록 추가 api.\n
          - 유저라면 헤더에 토큰 필요\n
          - user_type, group_type 중에 type 선택필요"
        end
        params do
          requires :title, type: String
          optional :target_id, type: Integer
          requires :p_type, type: String, values: ['user_type', 'group_type']
        end
        post '', root: :playlists do
          target_id = if params[:p_type] == 'user_type'
                        current_user.id
                      else
                        params[:target_id]
                      end
          unless (params[:p_type] == 'group_type' and Playlist.find_by(ref_id: params[:target_id], p_type: 'group_type') == nil)
            playlist = {
              title: params[:title],
              ref_id: target_id,
              p_type: params[:p_type]
            }
            Playlist.create(playlist)
          end

          Playlist.delete(Playlist.order(:created_at).first) if Playlist.all.count > 100 #100개 초과인지 체크
        end

        desc "재생목록에 곡 추가" do
          detail "재생목록에 곡 추가 api.\n
          - song은 여러개의 song_id로 Array[Integer] Type"
        end
        params do
          requires :song, type: Array[Integer]
          requires :playlist_id, type: Integer
        end
        post '/song', root: :playlists do
          params[:song].each do |song_id|
            info = {
              song_id: song_id,
              playlist_id: params[:playlist_id],
              user_id: current_user.id
            }
            Playlistinfo.create(info)
          end
        end

        desc "재생목록 삭제" do
          detail "재생목록 삭제 api."
        end
        params do
          requires :playlist_id, type: Integer
        end
        delete '', root: :playlists do
          Playlist.delete_by(id: params[:playlist_id])
          infos = Playlistinfo.where(playlist_id: params[:playlist_id])
          infos.each do |info|
            Playlistinfo.delete(info)
          end
        end

        desc "재생목록의 곡 삭제" do
          detail "재생목록의 곡 삭제 api.\n
          - song은 여러개의 song_id로 Array[Integer] Type"
        end
        params do
          requires :song, type: Array[Integer]
          requires :playlist_id, type: Integer
        end
        delete '/song', root: :playlists do
          params[:song].each do |song_id|
            Playlistinfo.delete_by(song_id:song_id, playlist_id: params[:playlist_id])
          end
        end

        desc "재생목록 조회" do
          detail "재생목록 조회 api."
        end
        params do
          requires :playlist_id, type: Integer
          optional :page, type: Integer
          optional :per_page, type: Integer
        end
        get '/song', root: :playlists do
          infos = Playlistinfo.where(playlist_id: params[:playlist_id])
          infoArray = Array.new
          infos.each do |info|
            song = Song.find_by(id: info.song_id)
            infoArray << song if song
          end
          return Kaminari.paginate_array(infoArray).page(params[:page]).per(params[:per_page])
        end

        desc "그룹별 재생목록 목록 조회" do
          detail "그룹별 재생목록 목록 조회 api."
        end
        params do
          requires :group_id, type: Integer
          optional :page, type: Integer
          optional :per_page, type: Integer
        end
        get '/group', root: :playlists do
          Playlist.where(ref_id: params[:group_id], p_type: 'group_type').page(params[:page]).per(params[:per_page])
        end

        desc "유저별 재생목록 목록 조회" do
          detail "유저별 재생목록 목록 조회 api."
        end
        params do
          optional :page, type: Integer
          optional :per_page, type: Integer
        end
        get '/user', root: :playlists do
          Playlist.where(ref_id: current_user.id, p_type: 'user_type').page(params[:page]).per(params[:per_page])
        end

      end

      end
  end
end