require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'should create user with valid params' do
    assert_difference('User.count', 1) do
      post users_url, params: {
        user: {
          email_address: 'test@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        }
      }, as: :json
    end
    assert_response :created
    body = JSON.parse(@response.body)
    assert_equal 'Account created successfully.', body['message']
    assert @response.cookies['session_id'].present?
  end

  test 'should normalize email address' do
    post users_url, params: {
      user: {
        email_address: '  TEST@Example.COM  ',
        password: 'password123',
        password_confirmation: 'password123'
      }
    }, as: :json
    assert_response :created
    user = User.last
    assert_equal 'test@example.com', user.email_address
  end

  test 'should not create user with invalid params' do
    assert_no_difference('User.count') do
      post users_url, params: {
        user: {
          email_address: '',
          password: 'password123',
          password_confirmation: 'wrong'
        }
      }, as: :json
    end
    assert_response :unprocessable_entity
    body = JSON.parse(@response.body)
    assert body['errors'].present?
  end

  test 'should not allow duplicate email addresses' do
    User.create!(email_address: 'test@example.com', password: 'password123', password_confirmation: 'password123')
    assert_no_difference('User.count') do
      post users_url, params: {
        user: {
          email_address: 'test@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        }
      }, as: :json
    end
    assert_response :unprocessable_entity
    body = JSON.parse(@response.body)
    assert_match(/email/i, body['errors'].join)
  end

  test 'should return error if password confirmation does not match' do
    post users_url, params: {
      user: {
        email_address: 'another@example.com',
        password: 'password123',
        password_confirmation: 'different'
      }
    }, as: :json
    assert_response :unprocessable_entity
    body = JSON.parse(@response.body)
    assert_match(/confirmation/i, body['errors'].join)
  end

  test 'should return error if required fields are missing' do
    post users_url, params: { user: { email_address: '' } }, as: :json
    assert_response :unprocessable_entity
    body = JSON.parse(@response.body)
    assert body['errors'].present?
  end

  test 'GET /users/new returns not implemented' do
    get new_user_url, as: :json
    assert_response :not_implemented
    body = JSON.parse(@response.body)
    assert_equal 'Not implemented', body['error']
  end
end 
