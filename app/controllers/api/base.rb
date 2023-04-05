module API
  class Base < Grape::API
    helpers AuthHelpers
    helpers do
      def unauthorized_error!
        error!('Unauthorized', 401)
      end
    end

    mount API::V1::Songs
    mount API::V1::Playlists
    mount API::V1::Groups
    mount API::V1::Users

    add_swagger_documentation format: :json,
                              hide_documentation_path: false,
                              api_version: "v1",
                              info: {
                                title: "Ringle Music V1 API",
                              },
                              mount_path: "/api/v1/apidoc",
                              tags: [
                                { name: "playlists", description: "재생목록 API" },
                                { name: "songs", description: "음원 API" },
                                { name: "groups", description: "그룹 API" },
                                { name: "users", description: "사용자 API" }
                              ]
  end

end