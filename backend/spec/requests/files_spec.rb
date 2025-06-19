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
end