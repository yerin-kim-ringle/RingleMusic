module API
  module V1
    class Groups < Grape::API
      version 'v1', using: :path
      format :json
      prefix :api

      resource :groups do
        desc "Manage Groups"

        params do
          requires :name, type: String
          requires :user_id, type: Integer
        end
        post "", root: :groups do  #그룹 추가 api
          group = {
            name: params[:name],
            user_id: params[:user_id]
          }
          Group.create(group)
        end

        params do
          requires :group_id, type: Integer
          requires :user_id, type: Integer
        end
        post "/join", root: :groups do  #사용자가 그룹 참여 api
          user_group = {
            group_id:params[:group_id],
            user_id: params[:user_id]
          }
          UserGroup.create(user_group)
        end

        params do
          requires :group_id, type: Integer
          requires :user_id, type: Integer
        end
        delete "", root: :groups do  #사용자가 그룹 탈퇴 api
          UserGroup.delete_by(user_id: params[:user_id],group_id: params[:group_id])
          ids=Playlist.where(p_type:"group_type", ref_id: params[:group_id]).ids
          ids.each do |id|
            Playlistinfo.delete_by(user_id: params[:user_id],playlist_id: id)
          end
        end

      end

    end
  end
end