# frozen_string_literal: true

class Quiz
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :total_score, type: Float
  field :published, type: Mongoid::Boolean
  belongs_to :creator, class_name: 'User', foreign_key: 'created_by'
end
