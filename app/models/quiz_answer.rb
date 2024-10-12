class QuizAnswer
  include Mongoid::Document
  include Mongoid::Timestamps
  field :score, type: Float
  field :answers, type: Array, default: []
  embeds_one :user
  belongs_to :quiz
end
