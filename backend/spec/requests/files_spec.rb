require 'rails_helper'

describe 'FilesController', type: :request do
  let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }

  context 'when user is not authenticated' do
    it 'returns unauthorized' do
      get '/files'
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'when user is authenticated' do
    before do
      # Simulate authentication by stubbing Current.session a/nd Current.user
      session_double = double('Session', user: user)
      allow(Current).to receive(:session).and_return(session_double)
      allow(Current).to receive(:user).and_return(user)
      # Create a file for the user
      UserFile.create!(user: user, file_name: 'testfile.txt', file_size: 123, file_created_at: Time.now, file_path: '/some/path')
    end

    it 'returns a list of files with metadata' do
      get '/files'
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json['files']).to be_an(Array)
      expect(json['files'].first['filename']).to eq('testfile.txt')
      expect(json['files'].first).to have_key('size')
      expect(json['files'].first).to have_key('created_at')
      expect(json['files'].first).to have_key('path')
    end
  end

  describe 'GET /files/:file_id' do
    let(:user) { User.create!(email_address: 'test@example.com', password: 'password') }
    let(:other_user) { User.create!(email_address: 'other@example.com', password: 'password') }
    let!(:user_file) { UserFile.create!(user: user, file_name: 'testfile.txt', file_size: 123, file_created_at: Time.now, file_path: '/some/path') }
    let!(:other_file) { UserFile.create!(user: other_user, file_name: 'otherfile.txt', file_size: 456, file_created_at: Time.now, file_path: '/other/path') }

    context 'when user is not authenticated' do
      it 'returns unauthorized' do
        get "/files/#{user_file.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is authenticated' do
      before do
        session_double = double('Session', user: user)
        allow(Current).to receive(:session).and_return(session_double)
        allow(Current).to receive(:user).and_return(user)
      end

      it 'returns the file metadata for the user file' do
        get "/files/#{user_file.id}"
        expect(response).to have_http_status(:success)
        json = JSON.parse(response.body)
        expect(json['filename']).to eq('testfile.txt')
        expect(json['size']).to eq(123)
        expect(json['created_at']).to eq(user_file.created_at.as_json)
        expect(json['path']).to eq('/some/path')
      end

      it 'returns not found for a file not owned by the user' do
        get "/files/#{other_file.id}"
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['error']).to eq('File not found')
      end

      it 'returns not found for a non-existent file' do
        get "/files/999999"
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['error']).to eq('File not found')
      end
    end
  end
end