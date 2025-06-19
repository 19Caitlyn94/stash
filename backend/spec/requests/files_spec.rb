require 'rails_helper'

describe 'FilesController', type: :request do
  let(:uploads_dir) { Rails.root.join('storage', 'uploads') }

  before do
    FileUtils.mkdir_p(uploads_dir)
    File.write(uploads_dir.join('testfile.txt'), 'test content')
  end

  after do
    FileUtils.rm_rf(uploads_dir)
  end

  context 'when user is not authenticated' do
    it 'redirects to the login page' do
      get '/files'
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'when user is authenticated' do
    before do
      # Simulate authentication by stubbing Current.session
      allow(Current).to receive(:session).and_return(double('Session'))
      allow_any_instance_of(ApplicationController).to receive(:authenticated?).and_return(true)
      allow_any_instance_of(ApplicationController).to receive(:require_authentication).and_return(true)
    end

    it 'returns a list of files with metadata' do
      get '/files'
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json['files']).to be_an(Array)
      expect(json['files'].first['filename']).to eq('testfile.txt')
      expect(json['files'].first).to have_key('size')
      expect(json['files'].first).to have_key('created_at')
    end
  end
end