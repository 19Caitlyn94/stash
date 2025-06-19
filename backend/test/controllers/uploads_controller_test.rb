require 'test_helper'

class UploadsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email_address: 'test@example.com', password: 'password123', password_confirmation: 'password123')
    @session = @user.sessions.create!(user_agent: 'TestAgent', ip_address: '127.0.0.1')
    @headers = { 'Cookie' => "session_id=#{@session.id}" }
  end

  def upload_file(filename, content_type, size: 1024)
    file = Tempfile.new([File.basename(filename, '.*'), File.extname(filename)])
    file.binmode
    file.write('a' * size)
    file.rewind
    uploaded = Rack::Test::UploadedFile.new(file.path, content_type, original_filename: filename)
    [uploaded, file]
  end

  test 'should upload allowed file type' do
    uploaded, file = upload_file('test.jpg', 'image/jpeg')
    assert_difference('UserFile.count', 1) do
      post '/uploads', params: { file: uploaded }, headers: @headers
    end
    assert_response :created
    body = JSON.parse(@response.body)
    assert body['id'].present?
    assert body['uuid'].present?
    file.close!
  end

  test 'should reject unsupported file type' do
    uploaded, file = upload_file('test.exe', 'application/octet-stream')
    assert_no_difference('UserFile.count') do
      post '/uploads', params: { file: uploaded }, headers: @headers
    end
    assert_response :unprocessable_entity
    body = JSON.parse(@response.body)
    assert_match(/unsupported/i, body['error'])
    file.close!
  end

  test 'should reject file larger than 2MB' do
    uploaded, file = upload_file('big.png', 'image/png', size: 2 * 1024 * 1024 + 1)
    assert_no_difference('UserFile.count') do
      post '/uploads', params: { file: uploaded }, headers: @headers
    end
    assert_response :unprocessable_entity
    body = JSON.parse(@response.body)
    assert_match(/too large/i, body['error'])
    file.close!
  end

  test 'should require authentication' do
    uploaded, file = upload_file('test.jpg', 'image/jpeg')
    post '/uploads', params: { file: uploaded }
    assert_response :unauthorized
    file.close!
  end

  test 'should return error if no file uploaded' do
    post '/uploads', headers: @headers
    assert_response :bad_request
    body = JSON.parse(@response.body)
    assert_match(/no file/i, body['error'])
  end
end 
