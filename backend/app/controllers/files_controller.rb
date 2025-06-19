class FilesController < ApplicationController

  # GET /files
  def index
    user_files = Current.user&.user_files || []
    files = user_files.map do |file|
      {
        id: file.id,
        filename: file.file_name,
        content_type: file.file_type,
        file_size: file.file_size,
        created_at: file.created_at
      }
    end
    render json: { files: files }
  end

  # GET /files/:file_id
  def show
    user_file = Current.user&.user_files&.find_by(id: params[:file_id])
    if user_file
      # If ?download=true, send the file as an attachment
      if params[:download].present?
        return send_file user_file.file_path,
          filename: user_file.file_name,
          type: user_file.file_type,
          disposition: 'attachment'
      end
      render json: {
        filename: user_file.file_name,
        size: user_file.file_size,
        created_at: user_file.created_at,
        path: user_file.file_path
      }
    else
      render json: { error: 'File not found' }, status: :not_found
    end
  end
end 
