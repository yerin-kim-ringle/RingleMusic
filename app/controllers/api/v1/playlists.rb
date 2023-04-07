module API
  module V1
    class Playlists < Grape::API
      version 'v1', using: :path
      format :json
      prefix :api

      resource :playlists do
        desc 'Manage Songs'

        desc '유저/그룹 재생목록 추가' do
          detail "유저/그룹 재생목록 추가 api.\n
          - 헤더에 토큰 필요\n
          - user_type, group_type 중에 type 선택필요"
        end
        params do
          requires :title, type: String
          optional :target_id, type: Integer
          requires :p_type, type: String, values: %w[user_type group_type]
        end
        pos록t '', root: :playlists do
          target_id = params[:p_type] == 'user_type' ? current_user.id : params[:target_id]
          error! '그룹에 속한 유저만 추가할 수 있습니다', 401 if (params[:p_type] == 'group_type') && UserGroup.find_by(user_id: current_user.id, group_id: target_id).nil?
          if !((params[:p_type] == 'group_type') && (Playlist.find_by(ref_id: params[:target_id], p_type: 'group_type') != nil))
            playlist = {
              title: params[:title],
              ref_id: target_id,
              p_type: params[:p_type]
            }
            Playlist.create(playlist)
          else
            error! '이미 그룹 플레이리스트가 존재합니다', 500
          end
          Playlist.delete(Playlist.order(:created_at).first) if Playlist.all.count > 100 #100개 초과인지 체크
        end

        desc '재생목록에 곡 추가' do
          detail "재생목록에 곡 추가 api.\n
          - song은 여러개의 song_id로 Array[Integer] Type"
        end
        params do
          requires :song, type: Array[Integer]
          requires :playlist_id, type: Integer
        end
        post '/song', root: :playlists do
          group_id = Playlist.find_by(p_type: 'group_type', id:params[:playlist_id]).ref_id
          error! '그룹에 속한 유저만 추가할 수 있습니다', 401 if UserGroup.find_by(user_id: current_user.id, group_id: group_id) == nil
          params[:song].each do |song_id|
            info = {
              song_id: song_id,
              playlist_id: params[:playlist_id],
              user_id: current_user.id
            }
            Playlistinfo.create(info)
          end
        end

        desc '재생목록 삭제' do
          detail '재생목록 삭제 api.'
        end
        params do
          requires :playlist_id, type: Integer
        end
        delete '', root: :playlists do
          Playlist.delete_by(id: params[:playlist_id])
          Playlistinfo.delete_by(playlist_id: params[:playlist_id])
        end

        desc '재생목록의 곡 삭제' do
          detail "재생목록의 곡 삭제 api.\n
          - song은 여러개의 song_id로 Array[Integer] Type"
        end
        params do
          requires :song, type: Array[Integer]
          requires :playlist_id, type: Integer
        end
        delete '/song', root: :playlists do
          group_id = Playlist.find_by(p_type: 'group_type', id:params[:playlist_id]).ref_id
          error! '그룹에 속한 유저만 삭제할 수 있습니다', 401 if UserGroup.find_by(user_id: current_user.id, group_id: group_id) == nil
          Playlistinfo.delete_by('playlistinfos.playlist_id = ? and playlistinfos.song_id IN (?)', params[:playlist_id], params[:song])
        end

        desc '재생목록 조회' do
          detail '재생목록 조회 api.'
        end
        params do
          requires :playlist_id, type: Integer
          optional :page, type: Integer
          optional :per_page, type: Integer
        end
        get '/song', root: :playlists do
          Song
            .joins('INNER JOIN playlistinfos ON playlistinfos.song_id=songs.id')
            .where('playlistinfos.playlist_id = ?', params[:playlist_id])
            .page(params[:page]).per(params[:per_page])
        end

        desc '그룹별 재생목록 조회' do
          detail '그룹별 재생목록 조회 api.'
        end
        params do
          requires :group_id, type: Integer
          optional :page, type: Integer
          optional :per_page, type: Integer
        end
        get '/group', root: :playlists do
          Playlist.find_by(ref_id: params[:group_id], p_type: 'group_type')
        end

        desc '유저별 재생목록 목록 조회' do
          detail '유저별 재생목록 목록 조회 api.'
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