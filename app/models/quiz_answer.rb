# frozen_string_literal: true

class QuizAnswer
  include Mongoid::Document
  include Mongoid::Timestamps
  field :final_score, type: Float
  field :answers, type: Array, default: []
  field :user_id, type: String
  field :user_email, type: String
  belongs_to :quiz

  validates_uniqueness_of :quiz_id, scope: [:user_id]
end
