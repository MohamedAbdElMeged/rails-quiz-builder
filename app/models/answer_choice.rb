# frozen_string_literal: true

class AnswerChoice
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :correct, type: Mongoid::Boolean
  embedded_in :question
end
