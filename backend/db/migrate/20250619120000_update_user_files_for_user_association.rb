class UpdateUserFilesForUserAssociation < ActiveRecord::Migration[8.0]
  def change
    remove_column :user_files, :user_id, :integer
    remove_column :user_files, :file_created_at, :string
    add_reference :user_files, :user, null: false, foreign_key: true
  end
end 