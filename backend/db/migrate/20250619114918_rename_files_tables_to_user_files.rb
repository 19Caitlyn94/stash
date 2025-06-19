class RenameFilesTablesToUserFiles < ActiveRecord::Migration[8.0]
  def change
    rename_table :files_tables, :user_files
  end
end
