# frozen_string_literal: true

FactoryBot.define do
  factory :answer_choice do
    title { %w[yes no].sample }
    correct { [true, false].sample }
    created_at { DateTime.current }
  end
end
