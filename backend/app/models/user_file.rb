class UserFile < ApplicationRecord
  self.table_name = 'files_tables'
  belongs_to :user

  validates :file_name, presence: true
  validates :file_size, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :file_created_at, presence: true
  validates :file_path, presence: true
end 