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
  MAX_FILENAME_LENGTH = 128

  def create
    file = params[:file]
    unless file
      Rails.logger.warn("Upload failed: No file uploaded by user #{Current.user&.id}")
      return render json: { error: 'No file uploaded' }, status: :bad_request
    end

    if file.size == 0
      Rails.logger.warn("Upload failed: Empty file uploaded by user #{Current.user&.id}")
      return render json: { error: 'File is empty' }, status: :unprocessable_entity
    end

    unless ALLOWED_TYPES.keys.include?(file.content_type)
      Rails.logger.warn("Upload failed: Unsupported file type '#{file.content_type}' by user #{Current.user&.id}")
      return render json: { error: 'Unsupported file type' }, status: :unprocessable_entity
    end

    if file.size > MAX_SIZE
      Rails.logger.warn("Upload failed: File too large (#{file.size} bytes) by user #{Current.user&.id}")
      return render json: { error: 'File too large (max 2MB)' }, status: :unprocessable_entity
    end

    original_filename = file.original_filename.to_s
    if original_filename.length > MAX_FILENAME_LENGTH
      Rails.logger.warn("Upload failed: File name too long by user #{Current.user&.id}")
      return render json: { error: 'File name too long (max 128 characters)' }, status: :unprocessable_entity
    end

    # Sanitize file name (remove dangerous characters)
    sanitized_filename = original_filename.gsub(/[^a-zA-Z0-9.\-_]/, '_')

    ext = ALLOWED_TYPES[file.content_type]
    unique_id = SecureRandom.uuid
    filename = "#{unique_id}.#{ext}"
    storage_path = Rails.root.join('storage', 'uploads', filename)
    FileUtils.mkdir_p(storage_path.dirname)
    File.open(storage_path, 'wb') { |f| f.write(file.read) }

    user_file = UserFile.create!(
      user: Current.user,
      file_name: sanitized_filename,
      file_type: file.content_type,
      file_path: storage_path.to_s,
      file_size: file.size
    )

    # Log upload activity
    UploadActivity.create!(
      user: Current.user,
      user_file: user_file,
      ip_address: request.remote_ip,
      user_agent: request.user_agent
    )

    Rails.logger.info("User #{Current.user.id} uploaded file #{user_file.id} (#{sanitized_filename}, #{file.size} bytes)")
    render json: { id: user_file.id, uuid: unique_id }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.warn("Upload failed: Validation error for user #{Current.user&.id}: #{e.record.errors.full_messages.join(', ')}")
    render json: { error: e.record.errors.full_messages.join(', ') }, status: :unprocessable_entity
  rescue => e
    Rails.logger.error("Upload failed: Unexpected error for user #{Current.user&.id}: #{e.class} - #{e.message}")
    render json: { error: 'Unexpected error during upload' }, status: :internal_server_error
  end
end 
