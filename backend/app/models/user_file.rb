class UserFile < ApplicationRecord
  self.table_name = 'user_files'
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  has_many :upload_activities

  validates :file_name, presence: true
  validates :file_size, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :file_path, presence: true
end 
