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
  describe 'PATCH /quizzes/id' do
    context 'when creator and not published' do
      before do
        token = JwtHelper.encode(user.user_data)
        patch "/api/v1/quizzes/#{unpublished_quiz.id}", params: {
          quiz: {
            title: 'Test Updated'
          }
        }, headers: {
          Authorization: "Bearer #{token}"
        }
      end
      it 'should update successfully' do
        expect(response.status).to eq(200)
        expect(json['title']).to eq('Test Updated')
      end
    end
    context 'when creator and published' do
      before do
        token = JwtHelper.encode(user.user_data)
        patch "/api/v1/quizzes/#{published_quiz.id}", params: {
          quiz: {
            title: 'Test Updated'
          }
        }, headers: {
          Authorization: "Bearer #{token}"
        }
      end
      it "shouldn't update and return error" do
        expect(response.status).to eq(422)
        expect(json['error']).to eq('Published Quiz can\'t be updated')
      end
    end
    context 'when not creator' do
      before do
        user2 = create(:user, email: 'abbas@abbas.com')
        token = JwtHelper.encode(user2.user_data)
        patch "/api/v1/quizzes/#{unpublished_quiz.id}", params: {
          quiz: {
            title: 'Test Updated'
          }
        }, headers: {
          Authorization: "Bearer #{token}"
        }
      end
      it "shouldn't update and return error" do
        expect(response.status).to eq(403)
        expect(json['error']).to eq('Can\'t edit other quizzes')
      end
    end
    context 'when not logged in' do
      before do
        patch "/api/v1/quizzes/#{unpublished_quiz.id}", params: {
          title: 'Test Updated'
        }
      end
      it "shouldn't update and return unauthorized" do
        expect(response.status).to eq(401)
      end
    end
    context 'when quiz not found' do
      before do
        token = JwtHelper.encode(user.user_data)
        patch "/api/v1/quizzes/#{unpublished_quiz.id}232532525223232", params: {
                                                                         title: 'Test Updated'
                                                                       },
                                                                       headers: {
                                                                         Authorization: "Beared #{token}"
                                                                       }
      end
      it "shouldn't update and return unauthorized" do
        expect(response.status).to eq(404)
        expect(json['error']).to eq('Quiz not found')
      end
    end
  end
  describe 'POST /quizzes' do
    context 'when not logged in' do
      before do
        post '/api/v1/quizzes', params: {
          quiz: {
            title: 'sdvdvdsv'
          }
        }
      end
      it "shouldn't create and return unauthorized" do
        expect(response.status).to eq(401)
      end
    end
    context 'when logged in with valid params' do
      before do
        params = {
          quiz: {
            title: 'quiz test case',
            published: false,
            questions: [
              {
                title: 'Is Moon a star?',
                question_type: 'single_answer',
                answer_choices: [
                  {
                    title: 'yes',
                    correct: false
                  },
                  {
                    title: 'no',
                    correct: true
                  }
                ]
              },
              {
                title: 'Temperature can be measured in',
                question_type: 'multiple_answer',
                answer_choices: [
                  {
                    title: 'Kelvin',
                    correct: true
                  },
                  {
                    title: 'Fahrenheit',
                    correct: true
                  },
                  {
                    title: 'Gram',
                    correct: false
                  },                  {
                    title: 'Litres',
                    correct: false
                  },                  {
                    title: 'Celsius',
                    correct: true
                  }
                ]
              }
            ]
          }
        }
        token = JwtHelper.encode(user.user_data)
        post '/api/v1/quizzes', params:, headers: {
          Authorization: "Bearer #{token}"
        }
      end
      it 'should create the quiz successfully and return status 201' do
        expect(response.status).to eq(201)
        expect(json['title']).to eq('quiz test case')
      end
    end

    context 'when logged in with invalid params' do
      before do
        params = {
          quiz: {
            title: 'quiz invalid test case title',
            published: false
          }
        }
        token = JwtHelper.encode(user.user_data)
        post '/api/v1/quizzes', params:, headers: {
          Authorization: "Bearer #{token}"
        }
      end
      it "shouldn't create the quiz and return status 422" do
        expect(response.status).to eq(422)
        expect(json['error']).to eq('Questions number should be between 1 and 10')
      end
    end
  end
  describe 'DELETE /quizzes/:id' do
    context "when user isn't logged in" do
      before do
        delete "/api/v1/quizzes/#{unpublished_quiz.id}"
      end
      it 'should return unauthorized' do
        expect(response.status).to eq(401)
      end
    end
    context "when user isn't creator" do
      before do
        user2 = create(:user, email: 'user2@user.com')
        token = JwtHelper.encode(user2.user_data)
        delete "/api/v1/quizzes/#{published_quiz.id}", headers: {
          Authorization: "Bearer #{token}"
        }
      end
      it 'should return forbidden' do
        expect(response.status).to eq(403)
      end
    end
    context 'when user is created' do
      before do
        token = JwtHelper.encode(user.user_data)
        delete "/api/v1/quizzes/#{published_quiz.id}", headers: {
          Authorization: "Bearer #{token}"
        }
      end
      it 'should delete successfully' do
        expect(response.status).to eq(200)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
