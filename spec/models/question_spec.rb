# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  let!(:user) { create :user}
  let!(:quiz) { create(:quiz, creator: user , questions_count: 1) }
  let!(:question) { quiz.questions.first}

  it 'question type should be either single type or multiple type' do
    expect(Question::QUESTION_TYPES).to include(question.question_type)
  end
end
