# frozen_string_literal: true

module Api
  module V1
    class QuizzesController < ApplicationController
      def index
        quizzes = Quiz.published_quizzes
        render json: quizzes, each_serializer: Api::V1::QuizSerializer, status: :ok
      end
    end
  end
end
