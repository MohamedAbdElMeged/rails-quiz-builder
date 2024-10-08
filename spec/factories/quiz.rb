# frozen_string_literal: true

FactoryBot.define do
  factory :quiz do
    title { Faker::Marketing.buzzwords }
    published { [true, false].sample }
    created_at { DateTime.current }
    association :creator, factory: :user
    transient do
      questions_count { (1...10).to_a.sample }
    end
    questions { build_list(:question, questions_count) }
  end
end
