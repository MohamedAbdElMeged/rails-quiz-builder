# frozen_string_literal: true

module Api
  module V1
    class QuizzesController < ApplicationController
      before_action :authorize_request, only: %i[update create destroy]
      before_action :set_quiz, only: %i[update destroy]
      before_action :validate_creator, only: %i[update destroy]

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
        if @quiz.update(quiz_params)
          render json: @quiz, serializer: Api::V1::QuizSerializer, status: :ok
        else
          render json: { error: @quiz.errors.full_messages.join(' , ') }, status: :unprocessable_entity
        end
      end

      def create
        quiz = @current_user.quizzes.build(quiz_params)
        if quiz.save
          render json: quiz, serializer: Api::V1::QuizSerializer, status: :created
        else
          render json: { error: quiz.errors.full_messages.join(' , ') }, status: :unprocessable_entity
        end
      end

      def destroy
        @quiz.destroy
        render json: @quiz, serializer: QuizSerializer, status: :ok
      end

      private

      def quiz_params
        params.require(:quiz).permit(:title, :published,
                                     questions: [:title, :question_type, { answer_choices: %i[title correct] }])
      end

      def set_quiz
        @quiz = Quiz.find_by(id: params[:id])
        render json: { error: 'Quiz not found' }, status: :not_found unless @quiz
        @quiz
      end

      def validate_creator
        return if @quiz.creator == @current_user

        render json: { error: "Can't edit other quizzes" },
               status: :forbidden
      end
    end
  end
end
