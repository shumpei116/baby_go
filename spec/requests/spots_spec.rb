require 'rails_helper'

RSpec.describe 'Spots', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/spots/index'
      expect(response).to have_http_status(:success)
    end
  end
end
