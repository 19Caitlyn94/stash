class FilesController < ApplicationController

  # GET /files
  def index
    uploads_dir = Rails.root.join('storage', 'uploads')
    files = []
    if Dir.exist?(uploads_dir)
      Dir.entries(uploads_dir).each do |filename|
        next if filename == '.' || filename == '..'
        path = uploads_dir.join(filename)
        stat = File.stat(path)
        files << {
          filename: filename,
          size: stat.size,
          created_at: stat.ctime
        }
      end
    end
    render json: { files: files }
  end

  # GET /files/:file_id
  def show
    # TODO: Implement file download logic
    render json: { message: 'Download file endpoint' }
  end
end 