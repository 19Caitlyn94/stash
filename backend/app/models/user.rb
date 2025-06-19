class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :user_files, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
