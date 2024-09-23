# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  describe "POST /sign_up" do
    context "with valid params" do
      
      it 'returns http created' do
        post '/api/v1/users/sign_up', params: {
          user: {
            email: "test@test.com",
            password: "Abcd1234",
            password_confirmation: "Abcd1234"
          }
        }
        expect(response.status).to eq(201)
        expect(User.first.email).to eq("test@test.com")
      end

    end
    
  end
  
end
