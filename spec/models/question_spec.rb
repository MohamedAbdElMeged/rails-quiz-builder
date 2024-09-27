# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  let!(:user) { create :user }
  let!(:quiz) { create(:quiz, creator: user, questions_count: 1) }
  let!(:question) { quiz.questions.first }

  it 'question type should be either single type or multiple type' do
    expect(Question::QUESTION_TYPES).to include(question.question_type)
  end
  context 'If question single answer' do
    let(:single_question) { create(:question, question_type: 'single_answer', quiz:) }
    it 'should contain one answer only' do
      expect(single_question.answer_choices.where(correct: true).size).to  eq(1)
    end
  end

  context 'If question multiple answer' do
    let(:single_question) { create(:question, question_type: 'multiple_answer', quiz:) }
    it 'should contain multiple correct_answers' do
      expect(single_question.answer_choices.where(correct: true).size).to  be > 1
    end
  end
end
