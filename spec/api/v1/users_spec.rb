# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  describe 'POST /sign_up' do
    context 'with valid params' do
      it 'create the user and return success response' do
        post '/api/v1/users/sign_up', params: {
          user: {
            email: 'test@test.com',
            password: 'Abcd1234',
            password_confirmation: 'Abcd1234'
          }
        }
        expect(response.status).to eq(201)
        expect(User.first.email).to eq('test@test.com')
        expect(json.keys).to eq(%w[id email token])
      end
    end
    context 'with already taken email' do
      before do
        create(:user, email: 'test@test.com')
      end
      it "shouldn't create the user and return error" do
        post '/api/v1/users/sign_up', params: {
          user: {
            email: 'test@test.com',
            password: 'Abcd1234',
            password_confirmation: 'Abcd1234'
          }
        }
        expect(response.status).to eq(422)
        expect(json.first).to eq('Email has already been taken')
      end
    end

    context "when password and password_confirmation don't match" do
      it "shouldn't create the user and return error" do
        post '/api/v1/users/sign_up', params: {
          user: {
            email: 'test@test.com',
            password: 'Abcd1234',
            password_confirmation: 'Abcd12345'
          }
        }
        expect(response.status).to eq(422)
        expect(json.first).to eq("Password confirmation doesn't match Password")
      end
    end
  end
  describe 'POST /sign_in' do
    before do
      create(:user, email: 'test@test.com')
    end

    context 'when correct data' do
      it 'should return success and token' do
        post '/api/v1/users/sign_in', params: {
          email: 'test@test.com',
          password: 'Abcd1234'
        }
        expect(response.status).to eq(200)
        expect(json.keys).to eq(%w[id email token])
      end
    end

    context 'when incorrect data' do
      it 'should return unauthorized' do
        post '/api/v1/users/sign_in', params: {
          email: 'test@test.com',
          password: 'Abcd12345'
        }
        expect(response.status).to eq(401)
        expect(json['error']).to eq('Invalid email or password')
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
