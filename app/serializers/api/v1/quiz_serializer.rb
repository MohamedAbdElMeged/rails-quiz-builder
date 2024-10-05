# frozen_string_literal: true

module Api
  module V1
    class QuizSerializer < ActiveModel::Serializer
      attributes :id, :title, :published, :total_score
      has_one :creator
      attribute :_questions

      def _questions
        object.questions.map do |question|
          {
            id: question.id,
            title: question.title,
            question_type: question.question_type,
            answer_choices: map_answer_choices(question)
          }
        end
      end

      def map_answer_choices(question)
        answer_choices = []
        question.answer_choices.each do |answer_choice|
          x = {
            id: answer_choice.id,
            title: answer_choice.title,
            correct: show_correct? ? answer_choice.correct : nil
          }
          answer_choices.push(x)
        end
        answer_choices
      end

      def show_correct?
        current_user == object.creator
      end

      def current_user
        @instance_options[:current_user]
      end
    end
  end
end
