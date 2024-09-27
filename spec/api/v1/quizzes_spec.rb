# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::QuizzesController, type: :request do
  let!(:user) { create(:user) }
  let!(:published_quizzes) do
    create_list(:quiz, 5, questions_count: (2..5).to_a.sample, published: true, creator: user)
  end
  let!(:unpublished_quizzes) do
    create_list(:quiz, 5, questions_count: (2..5).to_a.sample, published: false, creator: user)
  end
  describe 'GET /quizzes' do
    it 'should return published quizzes only ' do
      get '/api/v1/quizzes'
      expect(response.status).to eq(200)
      expect(json.size).to eq(5)
      expect(json.map { |i| i['published'] }.uniq).to eq([true])
    end
  end
end
