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

      end

    end
  end
end