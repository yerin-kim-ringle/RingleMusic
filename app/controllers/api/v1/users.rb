module API
  module V1
    class Users < Grape::API
      version 'v1', using: :path
      format :json
      prefix :api

      namespace :users do
        namespace :register do # 회원가입
          before do
            @user_mobile_number = UserService.new(
              params[:name], params[:mobile_number], params[:email], params[:password]
            )
          end
          desc '회원가입' do
            detail "회원가입 api. \n
            - email 중복 불가능
            - password 6자 이상"
          end
          params do
            requires :name, type: String
            requires :mobile_number, type: String
            requires :email, type: String
            requires :password, type: String
          end
          post do
            @user_mobile_number.register
          end
        end

        namespace :login do # 로그인
          before do
            @login_user = UserService.new(
              params[:name], params[:mobile_number], params[:email], params[:password]
            )
          end
          after do
            header 'Authorization', @login_user.token
          end
          desc '로그인' do
            detail "로그인 api. \n
            - 반환값 Authorization이 토큰 값"
          end
          params do
            requires :email, type: String
            requires :password, type: String
          end
          post do
            @login_user.login
          end
        end
      end
    end
  end
end