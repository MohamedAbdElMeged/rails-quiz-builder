# frozen_string_literal: true

module Api
  module V1
    class QuizzesController < ApplicationController
      before_action :authenticate_request, only: %i[update create destroy my_quizzes my_quiz submit]
      before_action :set_quiz, only: %i[update destroy my_quiz submit]
      before_action :validate_creator, only: %i[update destroy my_quiz]

      def index
        quizzes = Quiz.published_quizzes
        render json: quizzes, each_serializer: Api::V1::QuizSerializer, status: :ok
      end

      def show
        quiz = Quiz.published_quizzes.find_by(id: params[:id])
        if quiz
          render json: quiz, serializer: Api::V1::QuizSerializer, current_user: @current_user, status: :ok
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

      def my_quizzes
        quizzes = @current_user.quizzes
        render json: quizzes, each_serializer: Api::V1::QuizSerializer, status: :ok, current_user: @current_user
      end

      def my_quiz
        render json: @quiz, serializer: Api::V1::QuizSerializer, status: :ok, current_user: @current_user
      end

      def submit
        quiz_answer = SubmitQuiz.new(@quiz, submit_params[:answers], @current_user).call
        if quiz_answer.save
          render json: quiz_answer, status: :ok
        else
          render json: quiz_answer.errors.full_messages, status: :ok
        end
      end

      private

      def submit_params
        params.permit(answers: [:question_id, { answer_ids: [] }])
      end

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
        return true if @quiz.creator == @current_user

        render json: { error: "Can't view other quizzes" },
               status: :forbidden
      end
    end
  end
end
