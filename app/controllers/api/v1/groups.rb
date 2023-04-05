module API
  module V1
    class Groups < Grape::API
      version 'v1', using: :path
      format :json
      prefix :api

      namespace :groups do
        desc "그룹 추가" do
          detail "그룹 추가 api. 그룹 이름은 unique함"
        end
        params do
          requires :name, type: String
        end
        post '', root: :groups do
          group = Group.create(name: params[:name])
          user_group = {
            group_id: group.id,
            user_id: current_user.id
          }
          UserGroup.create(user_group)
        end

        desc "사용자 그룹 참여" do
          detail "사용자가 그룹 참여 api. 헤더에 사용자 토큰 필요"
        end
        params do
          requires :group_id, type: Integer
        end
        post '/join', root: :groups do
          user_group = {
            group_id: params[:group_id],
            user_id: current_user.id
          }
          UserGroup.create(user_group) unless UserGroup.find_by(user_group) #이미 참여한 그룹이 아니라면 참여
        end

        desc "사용자가 그룹 탈퇴" do
          detail "사용자가 그룹 탈퇴 api. 헤더에 사용자 토큰 필요"
        end
        params do
          requires :group_id, type: Integer
        end
        delete '', root: :groups do
          UserGroup.delete_by(user_id: current_user.id, group_id: params[:group_id])
          ids = Playlist.where(p_type:'group_type', ref_id: params[:group_id]).ids
          ids.each do |id|
            Playlistinfo.delete_by(user_id: params[:user_id], playlist_id: id)
          end
        end

        desc "사용자가 속한 그룹 조회" do
          detail "사용자가 속한 그룹 조회 api. 헤더에 사용자 토큰 필요"
        end
        get '', root: :groups do
          groups=UserGroup.where(user_id:current_user.id)
          infoArray = Array.new
          groups.each do |group|
            infoArray << Group.find_by(id: group.id)
          end
          infoArray
        end

        desc "그룹별 사용자 이름 조회" do
          detail "그룹에 속한 사용자 이름 조회 api. "
        end
        params do
          requires :group_id, type: Integer
        end
        get 'user', root: :groups do
          infos=UserGroup.where(group_id:params[:group_id])
          infoArray = Array.new
          infos.each do |info|
            infoArray << User.find_by(id: info.user_id).name
          end
          infoArray
        end

      end

    end
  end
end