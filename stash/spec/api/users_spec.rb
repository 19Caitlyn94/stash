require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  describe 'POST /users' do
    let(:valid_params) do
      {
        user: {
          email_address: 'test@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        }
      }
    end

    let(:invalid_params) do
      {
        user: {
          email_address: '',
          password: 'password123',
          password_confirmation: 'wrong'
        }
      }
    end

    it 'creates a user with valid params' do
      expect {
        post '/users', params: valid_params
      }.to change(User, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to eq({ 'message' => 'Account created successfully.' })
      # Check session cookie is set
      expect(response.cookies['session_id']).to be_present
    end

    it 'normalizes email address (downcase, strip)' do
      params = {
        user: {
          email_address: '  TEST@Example.COM  ',
          password: 'password123',
          password_confirmation: 'password123'
        }
      }
      post '/users', params: params
      expect(response).to have_http_status(:created)
      user = User.last
      expect(user.email_address).to eq('test@example.com')
    end

    it 'does not create a user with invalid params' do
      expect {
        post '/users', params: invalid_params
      }.not_to change(User, :count)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to have_key('errors')
      expect(JSON.parse(response.body)['errors']).not_to be_empty
    end

    it 'does not allow duplicate email addresses' do
      User.create!(email_address: 'test@example.com', password: 'password123', password_confirmation: 'password123')
      post '/users', params: valid_params
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors'].join).to match(/email/i)
    end

    it 'returns error if password confirmation does not match' do
      params = {
        user: {
          email_address: 'another@example.com',
          password: 'password123',
          password_confirmation: 'different'
        }
      }
      post '/users', params: params
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors'].join).to match(/confirmation/i)
    end

    it 'returns error if required fields are missing' do
      params = { user: { email_address: '' } }
      post '/users', params: params
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).not_to be_empty
    end
  end

  describe 'GET /users/new' do
    it 'returns not implemented' do
      get '/users/new'
      expect(response).to have_http_status(:not_implemented)
      expect(JSON.parse(response.body)).to eq({ 'error' => 'Not implemented' })
    end
  end
end 
