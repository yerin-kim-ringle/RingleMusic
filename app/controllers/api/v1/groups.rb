module API
  module V1
    class Groups < Grape::API
      version 'v1', using: :path
      format :json
      prefix :api

      resource :groups do
        desc 'Manage Groups'

        params do
          requires :name, type: String
        end
        post '', root: :groups do  #그룹 추가 api
          group = Group.create(name: params[:name])
          user_group = {
            group_id: group.id,
            user_id: current_user.id
          }
          UserGroup.create(user_group)
        end

        params do
          requires :group_id, type: Integer
        end
        post '/join', root: :groups do  #사용자가 그룹 참여 api
          user_group = {
            group_id: params[:group_id],
            user_id: current_user.id
          }
          UserGroup.create(user_group) unless UserGroup.find_by(user_group) #이미 참여한 그룹이 아니라면 참여
        end

        params do
          requires :group_id, type: Integer
        end
        delete '', root: :groups do  #사용자가 그룹 탈퇴 api
          UserGroup.delete_by(user_id: current_user.id, group_id: params[:group_id])
          ids = Playlist.where(p_type:'group_type', ref_id: params[:group_id]).ids
          ids.each do |id|
            Playlistinfo.delete_by(user_id: params[:user_id], playlist_id: id)
          end
        end

      end

    end
  end
end