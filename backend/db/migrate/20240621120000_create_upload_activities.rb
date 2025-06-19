class CreateUploadActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :upload_activities do |t|
      t.references :user, null: false, foreign_key: true
      t.references :user_file, null: false, foreign_key: true
      t.datetime :uploaded_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.string :ip_address
      t.string :user_agent
      t.timestamps
    end
    # add_index :upload_activities, :user_id # Removed to avoid duplicate index error
    add_index :upload_activities, :uploaded_at
  end
end 
