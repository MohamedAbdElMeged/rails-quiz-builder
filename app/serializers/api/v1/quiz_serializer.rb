# frozen_string_literal: true

module Api
  module V1
    class QuizSerializer < ActiveModel::Serializer
      attributes :title, :published, :total_score, :questions
      has_many :questions
      has_one :creator
    end
  end
end
