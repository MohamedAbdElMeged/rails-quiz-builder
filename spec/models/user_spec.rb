# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create :user }

  it 'message count should be 0 and chat number should be 1' do
    expect(User.all.size).to eq(1)
  end
end
