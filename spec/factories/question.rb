# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title { Faker::Lorem.question }
    question_type { Question::QUESTION_TYPES.sample }
    created_at { DateTime.current }
    after(:build) do |question, _evaluator|
      if question.question_type == 'single_answer'
        question.answer_choices.push(FactoryBot.build(:answer_choice, title: 'no', correct: false))
        question.answer_choices.push(FactoryBot.build(:answer_choice, title: 'yes', correct: true))
      else
        answer_choices_size = (2..3).to_a.sample
        answer_choices_size.times do
          question.answer_choices.push(FactoryBot.build(:answer_choice, title: Faker::Lorem.word, correct: false))
        end
        question.answer_choices.push(FactoryBot.build(:answer_choice, title: Faker::Lorem.word, correct: true))
        question.answer_choices.push(FactoryBot.build(:answer_choice, title: Faker::Lorem.word, correct: true))
      end
    end
  end
end
