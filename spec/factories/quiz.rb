# frozen_string_literal: true

FactoryBot.define do
  factory :quiz do
    title { Faker::Marketing.buzzwords }
    total_score { [10.0, 20.0].sample }
    published { [true, false].sample }
    association :creator, factory: :user
  end
end
