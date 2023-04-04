RSpec.describe V1::Users, '/api/v1/user/register' do
  let(:mobile_number) { '01234567' }

  context 'with phone number' do
    it 'creates new user' do
      expect do
        post '/api/v1/user/register', params: { mobile_number: mobile_number }
      end.to change(User, :count).by 1
    end

    it 'responses the new created user' do
      post '/api/v1/user/register', params: { mobile_number: mobile_number }

      expect(json_body).to include mobile_number: mobile_number
      expect(json_body).to include status: 'pending'
      expect(json_body[:code]).to be_present
    end

    it 'responses with jwt authorization token' do
      post '/api/v1/user/register', params: { mobile_number: mobile_number }

      expect(response.headers['Authorization']).to match /(^[\w-]*\.[\w-]*\.[\w-]*$)/
    end

    context 'when mobile number is already registered' do
      let!(:user) { create(:user, mobile_number: mobile_number)}

      it 'responses with jwt token' do
        post '/api/v1/user/register', params: { mobile_number: mobile_number }

        expect(jwt_token).to match /(^[\w-]*\.[\w-]*\.[\w-]*$)/
      end
    end
  end

  context 'when confirm' do
    before do
      post '/api/v1/user/register', params: { mobile_number: mobile_number }
    end

    context 'with correct code' do
      it 'changes status from pending to confirmed' do
        put '/api/v1/user/verify', params: { code: response.body['code'] }, headers: { 'Authorization': "Bearer #{jwt_token}" }

        expect(json_body(reload: true)[:status]).to eq 'confirmed'
      end
    end

    context 'with wrong code' do
      it 'unable to confirm' do
        put '/api/v1/user/verify', params: { code: 'wrong-code' }, headers: { 'Authorization': "Bearer #{jwt_token}" }

        expect(json_body(reload: true)[:status]).to eq 'pending'
      end
    end

    context 'without authorized jwt token header' do
      it 'responses unauthorized' do
        put '/api/v1/user/verify', params: { code: json_body[:code] }

        expect(response).to be_unauthorized
      end
    end
  end
end