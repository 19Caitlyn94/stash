class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :user_files, class_name: 'UserFile', foreign_key: 'user_id', dependent: :destroy
  has_many :upload_activities

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
