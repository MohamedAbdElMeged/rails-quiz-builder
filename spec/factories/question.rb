# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title { Faker::Lorem.question }
    question_type { Question::QUESTION_TYPES.sample }
  end
end
