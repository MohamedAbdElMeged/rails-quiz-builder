# frozen_string_literal: true

module Api
  module V1
    class QuizzesController < ApplicationController
      before_action :authorize_request, only: [:update]
      before_action :set_quiz, only: [:update]
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
      def update
        return render json: {error: "Can't edit other quizzes"}, status: :forbidden unless @quiz.creator == @current_user
        return render json: {error: 'Quiz is published and can\'t be updated'}, status: :unprocessable_entity if @quiz.published
        if @quiz.update(quiz_params)
          render json: @quiz, serializer: Api::V1::QuizSerializer, status: :ok
        else
          render json: {error: @quiz.errors.full_messages.join(' , ')}, status: :unprocessable_entity
        end
      end
      private
      def quiz_params
        params.require(:quiz).permit(:title ,  questions: [:title , :question_type, { answer_choices: [ :title, :correct] }])
      end
      
      def set_quiz
        @quiz = Quiz.find_by(id: params[:id])
        render json: {error: "Quiz not found"}, status: :not_found unless @quiz
        @quiz
      end
      
    end
  end
end
