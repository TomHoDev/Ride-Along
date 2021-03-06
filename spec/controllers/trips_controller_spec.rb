require 'rails_helper'

RSpec.describe TripsController, type: :controller do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:trip) { FactoryGirl.create(:trip) }

  describe 'POST #create' do
    it 'responds with status code 201' do
      post :create, params: {user_id: user.id, type: "to_home"}
      expect(response).to have_http_status 201
    end

    it 'adds a trip to the database' do
      expect { post(:create, {user_id: user.id, type: 'to_home' }) }.to change(Trip, :count).by(1)
    end

    it 'returns the newly created trip' do
      post :create, params: {user_id: user.id, type: 'to_home'}
      expect(Trip.new(response_body).valid?).to eq(true)
    end
  end

  describe 'GET #index' do
    it 'returns the trips where users are the driver' do
      user.trips << trip
      get :index, params: {user_id: user.id}
      expect(Trip.new(response_body[:trips][0])).to eq(trip)
    end

    it 'returns the trips where users are a rider' do
      trip.riders << user
      get :index, params: {user_id: user.id}
      expect(Trip.new(response_body[:rides][0])).to eq(trip)
    end
  end

  describe 'PATCH update' do
    it 'increases the number of riders by 1' do
      expect { patch(:update, {user_id: user.id, trip_id: trip.id }) }.to change(trip.riders, :count).by(1)
    end
    it 'adds the user to the riders list' do
      patch :update, params: {user_id: user.id, trip_id: trip.id}
      expect(trip.riders).to include(user)
    end
  end

  describe 'DELETE destroy' do
    it 'removes the post from the database' do
      delete :destroy, params: {trip_id: trip.id}
      expect(Trip.all).not_to include(trip)
    end
  end
end

# def response_body
#   JSON.parse(response.body)
# end
