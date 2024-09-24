# frozen_string_literal: true

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  has_secure_password
  attr_accessor :token

  field :email, type: String
  field :password_digest, type: String

  validates_presence_of :email
  validates_uniqueness_of :email

  has_many :quizzes, class_name: 'Quiz', foreign_key: 'created_by'

  def user_data
    {
      id:,
      email:
    }
  end
end
