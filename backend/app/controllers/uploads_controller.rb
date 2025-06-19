class UploadsController < ApplicationController
  before_action :require_authentication

  ALLOWED_TYPES = {
    'image/jpeg' => 'jpg',
    'image/png'  => 'png',
    'image/gif'  => 'gif',
    'image/svg+xml' => 'svg',
    'text/plain' => 'txt',
    'text/markdown' => 'md',
    'text/csv' => 'csv'
  }.freeze
  MAX_SIZE = 2.megabytes

  def create
    file = params[:file]
    unless file
      return render json: { error: 'No file uploaded' }, status: :bad_request
    end

    unless ALLOWED_TYPES.keys.include?(file.content_type)
      return render json: { error: 'Unsupported file type' }, status: :unprocessable_entity
    end

    if file.size > MAX_SIZE
      return render json: { error: 'File too large (max 2MB)' }, status: :unprocessable_entity
    end

    ext = ALLOWED_TYPES[file.content_type]
    unique_id = SecureRandom.uuid
    filename = "#{unique_id}.#{ext}"
    storage_path = Rails.root.join('storage', 'uploads', filename)
    FileUtils.mkdir_p(storage_path.dirname)
    File.open(storage_path, 'wb') { |f| f.write(file.read) }

    user_file = UserFile.create!(
      user: Current.user,
      file_name: file.original_filename,
      file_type: file.content_type,
      file_path: storage_path.to_s,
      file_size: file.size,
      file_created_at: Time.current
    )

    render json: { id: user_file.id, uuid: unique_id }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.full_messages.join(', ') }, status: :unprocessable_entity
  end
end 
