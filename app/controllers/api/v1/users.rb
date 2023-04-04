module API
  module V1
    class Users < Grape::API
      version 'v1', using: :path
      format :json
      prefix :api

      namespace :user do
        namespace :register do
          before do
            @user_mobile_number = UserRegistrationWithMobileNumberService.new(params[:mobile_number],params[:email],params[:password],params[:encrypted_password])
          end

          # set response headers
          after do
            header 'Authorization', @user_mobile_number.token
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