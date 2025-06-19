class FilesController < ApplicationController
  allow_unauthenticated_access

  # GET /files
  def index
    user_files = Current.user&.user_files || []
    files = user_files.map do |file|
      {
        filename: file.file_name,
        size: file.file_size,
        created_at: file.file_created_at,
        path: file.file_path
      }
    end
    render json: { files: files }
  end

  # GET /files/:file_id
  def show
    # TODO: Implement file download logic
    render json: { message: 'Download file endpoint' }
  end
end 