module API
  module V1
    class Likes < Grape::API
      version 'v1', using: :path
      format :json
      prefix :api

      resource :likes do
        desc 'Manage likes'

        desc '좋아요' do
          detail "좋아요 api. 헤더에 사용자 토큰 필요\n
          - 이미 좋아요를 눌렀다면 취소됨(status가 0으로 변경)"
        end
        params do
          requires :song_id, type: Integer
        end
        post '', root: :playlists do
          song = Song.find_by(id: params[:song_id])
          like = Like.find_by(user_id: current_user.id, song_id: params[:song_id])
          if like.nil?
            song.liked(false)
            like.new_liked
          else
            song.liked(like.status)
            like.liked
          end
        end
      end
    end
  end
end
