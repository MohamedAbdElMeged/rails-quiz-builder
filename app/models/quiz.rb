# frozen_string_literal: true

class Quiz
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String

  field :published, type: Mongoid::Boolean, default: false
  belongs_to :creator, class_name: 'User', foreign_key: 'created_by'
  embeds_many :questions
  validate :number_of_questions_in_quiz
  validate :published_quiz, on: :update
  scope :published_quizzes, -> { where(published: true) }
  scope :unpublished_quizzes, -> { where(published: false) }

  def number_of_questions_in_quiz
    errors.add(:questions, 'number should be between 1 and 10') if questions.size > 10 || questions.empty?
  end

  def published_quiz
    errors.add(:published, 'Quiz can\'t be updated') if published_was
  end

  def total_score
    questions.size
  end
end
