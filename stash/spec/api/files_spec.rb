require 'rails_helper'

RSpec.describe 'Api::FilesController', type: :request do
  describe 'GET /api/files' do
    it 'returns a successful response' do
      get '/api/files'
      expect(response).to have_http_status(:success)
      expect(response.body).to include('List files endpoint')
    end
  end

  describe 'GET /api/files/:id' do
    it 'returns a successful response' do
      get '/api/files/1'
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Download file endpoint')
    end
  end

  describe 'GET /api/files/:id/preview' do
    it 'returns a successful response' do
      get '/api/files/1/preview'
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Preview file endpoint')
    end
  end

  describe 'POST /api/files/:id/upload' do
    it 'returns a successful response' do
      post '/api/files/1/upload'
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Upload endpoint')
    end
  end
end 