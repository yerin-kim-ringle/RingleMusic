module API
  module V1
    class Playlists < Grape::API
      version 'v1', using: :path
      format :json
      prefix :api

      resource :playlists do
        desc "Manage Songs"

        params do
          requires :title, type: String
          requires :target_id, type: Integer
        end
        post "/user", root: :playlists do  #유저 재생목록 추가 api
          playlist = {
            title: params[:title],
            ref_id: params[:user_id],
            p_type: "user_type"
          }
          Playlist.create(playlist)
        end

        params do
          requires :title, type: String
          requires :group_id, type: Integer
        end
        post "/group", root: :playlists do  #그룹 재생목록 추가 api
          playlist = {
            title: params[:title],
            ref_id: group_id,
            p_type: "group_type"
          }
          Playlist.create(playlist)
        end

        params do
          requires :song, type: Array[Integer]
          requires :playlist_id, type:Integer
        end
        post "/song", root: :playlists do  #재생목록에 곡 추가 api
          params[:song].each do |song_id|
            info={
              song_id: song_id,
              playlist_id: params[:playlist_id]
            }
            Playlistinfo.create(info)
          end
        end

        params do
          requires :playlist_id, type:Integer
        end
        delete "", root: :playlists do  #재생목록 삭제 api
          playlist = Playlist.find_by(id: params[:playlist_id])
          Playlist.delete(playlist)

          infos = Playlistinfo.where(playlist_id: params[:playlist_id])
          infos.each do |info|
            Playlistinfo.delete(info)
          end
        end

        params do
          requires :song, type: Array[Integer]
          requires :playlist_id, type:Integer
        end
        delete "/song", root: :playlists do  #재생목록에 곡 삭제 api
          infos = Playlistinfo.where(playlist_id: params[:playlist_id])
          infos.each do |info|
            Playlistinfo.delete(info)
          end
        end

        params do
          requires :playlist_id, type:Integer
        end
        get "/song", root: :playlists do  #재생목록 조회 api
          infos = Playlistinfo.where(playlist_id: params[:playlist_id])
          infoArray = Array.new
          infos.each do |info|
            infoArray << Song.find_by(id: info.song_id) if info.song_id
          end
          return infoArray
        end

        params do
          requires :target_id, type:Integer
          requires :p_type, type:Integer
        end
        get "", root: :playlists do  #유저별/ 그룹별 재생목록 목록 조회 api
          Playlist.where(ref_id: params[:target_id],p_type: params[:p_type])
        end

      end

      end
  end
end