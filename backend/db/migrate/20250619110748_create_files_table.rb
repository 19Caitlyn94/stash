class CreateFilesTable < ActiveRecord::Migration[8.0]
  def change
    create_table :user_files do |t|
      t.integer :user_id
      t.string :file_name
      t.string :file_type
      t.string :file_path
      t.integer :file_size
      t.string :file_created_at
      t.timestamps
    end
  end
end
