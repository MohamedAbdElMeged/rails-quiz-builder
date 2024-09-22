# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'Abcd1234' }
    password_confirmation { 'Abcd1234' }
  end
end
