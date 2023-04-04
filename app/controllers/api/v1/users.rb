module API
  module V1
    class Users < Grape::API
      version 'v1', using: :path
      format :json
      prefix :api

      namespace :user do
        namespace :register do
          before do
            @user_mobile_number = UserRegistrationWithMobileNumberService.new(
              params[:name], params[:mobile_number], params[:email], params[:password]
            )
          end

          # set response headers
          after do
            header 'Authorization', @user_mobile_number.token
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

        put :verify do
          current_user.verify(params[:code])
        end
      end
    end
  end
end