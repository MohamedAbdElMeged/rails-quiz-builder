# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :authorize_request, only: [:profile]
      def sign_up
        user = User.new(user_params)
        if user.save
          user.token = JwtHelper.encode(user.user_data)
          render json: user, status: :created, serializer: Api::V1::UserSerializer
        else
          render json: user.errors.full_messages, status: :unprocessable_entity
        end
      end

      def sign_in
        user = User.find_by(email: params[:email])
        return render json: {error: "User not found"}, status: :not_found unless user
        unless user.authenticate(params[:password])
          return render json: { error: 'Invalid email or password' },
                        status: :unauthorized
        end

        user.token = JwtHelper.encode(user.user_data)
        render json: user, status: :ok, serializer: Api::V1::UserSerializer
      end

      def profile
        render json: @current_user, serializer: Api::V1::UserSerializer, status: :ok
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
    end
  end
end
