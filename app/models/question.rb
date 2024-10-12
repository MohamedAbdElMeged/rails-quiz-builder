# frozen_string_literal: true

class Question
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :question_type, type: String, default: 'single_answer'

  QUESTION_TYPES = %w[single_answer multiple_answer].freeze

  validates :question_type, inclusion: { in: QUESTION_TYPES }
  embedded_in :quiz
  embeds_many :answer_choices
  validate :question_has_only_one_correct_answer_if_single_answer, if: -> { question_type == 'single_answer' }
  def question_has_only_one_correct_answer_if_single_answer
    answer_choices.select { |answer_choice| answer_choice.correct == true }.size == 1
  end
  def correctness_weight
    1.0 / answer_choices.select{ |answer_choice| answer_choice.correct == true }.size
  end
  def incorrectness_weight
    1.0 / answer_choices.select{ |answer_choice| answer_choice.correct == false }.size
  end
  
end
