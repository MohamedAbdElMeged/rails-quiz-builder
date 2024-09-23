# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Quiz, type: :model do
  let!(:user) { create :user }
  let!(:quiz) { create(:quiz, creator: user) }
  it 'question count should be between 1 or 10' do
    expect((1..10).to_a).to include(quiz.questions.size)
  end
end
