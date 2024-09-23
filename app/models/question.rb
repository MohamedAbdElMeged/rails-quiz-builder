# frozen_string_literal: true

class Question
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :question_type, type: String, default: 'single_answer'

  QUESTION_TYPES = %w[single_answer multiple_answer].freeze

  validates :question_type, inclusion: { in: QUESTION_TYPES }
  embedded_in :quiz
end
