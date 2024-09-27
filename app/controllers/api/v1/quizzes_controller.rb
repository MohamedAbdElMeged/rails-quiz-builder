# frozen_string_literal: true

module Api
  module V1
    class QuizzesController < ApplicationController
      def index
        quizzes = Quiz.published_quizzes
        render json: quizzes, each_serializer: Api::V1::QuizSerializer, status: :ok
      end

      def show
        quiz = Quiz.published_quizzes.find_by(id: params[:id])
        if quiz
          render json: quiz, serializer: Api::V1::QuizSerializer, status: :ok
        else
          render json: { error: 'Quiz not found' }, status: :not_found
        end
      end
    end
  end
end
