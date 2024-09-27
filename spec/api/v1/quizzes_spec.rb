# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
require 'rails_helper'

RSpec.describe Api::V1::QuizzesController, type: :request do
  let!(:user) { create(:user) }
  let!(:published_quizzes) do
    create_list(:quiz, 5, questions_count: (2..5).to_a.sample, published: true, creator: user)
  end
  let!(:unpublished_quizzes) do
    create_list(:quiz, 5, questions_count: (2..5).to_a.sample, published: false, creator: user)
  end
  let!(:published_quiz) { published_quizzes.first }
  let!(:unpublished_quiz) { unpublished_quizzes.first }

  describe 'GET /quizzes' do
    it 'should return published quizzes only ' do
      get '/api/v1/quizzes'
      expect(response.status).to eq(200)
      expect(json.size).to eq(5)
      expect(json.map { |i| i['published'] }.uniq).to eq([true])
    end
  end
  describe 'GET /quizzes/:id' do
    context 'if invalid id ' do
      before do
        get '/api/v1/quizzes/dummy_dummy'
      end
      it 'should return status not found with message quiz not found ' do
        expect(response.status).to eq(404)
        expect(json['error']).to eq('Quiz not found')
      end
    end
    context 'if valid id and published' do
      before do
        get "/api/v1/quizzes/#{published_quiz.id}"
      end
      it 'should return status ok with data' do
        expect(response.status).to eq(200)
        expect(json['title']).to eq(published_quiz.title)
      end
    end
    context 'if valid id and not published' do
      before do
        get "/api/v1/quizzes/#{unpublished_quiz.id}"
      end
      it 'should return status not found with message quiz not found' do
        expect(response.status).to eq(404)
        expect(json['error']).to eq('Quiz not found')
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
