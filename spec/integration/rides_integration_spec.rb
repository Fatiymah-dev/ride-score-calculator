require 'rails_helper'

RSpec.describe 'Rides Integration', type: :request do
  let!(:driver) { Driver.create!(home_address: '1600 Amphitheatre Parkway, Mountain View, CA') }
  let!(:rides_data) do
    [
      { start_address: '1 Infinite Loop, Cupertino, CA', destination_address: 'Apple Park, Cupertino, CA' },
      { start_address: '500 Terry A Francois Blvd, San Francisco, CA', destination_address: 'Pier 39, San Francisco, CA' },
      { start_address: '1000 Marina Blvd, Brisbane, CA', destination_address: 'Mission District, San Francisco, CA' }
    ]
  end

  describe 'POST /rides' do
    it 'creates and scores rides' do
      rides_data.each do |data|
        post "/drivers/#{driver.id}/rides", params: {
            ride: {
              start_address: data[:start_address],
              destination_address: data[:destination_address]
            }
          }      
          
            puts response.body
            puts response.status    
      end

      expect(Ride.count).to eq(3)
      expect(Ride.last.score.to_f).to be_a(Float)
    end
  end

  describe 'GET /rides' do
    it 'returns rides sorted by score' do
      rides_data.each do |data|
        Ride.create!(
            start_address: data[:start_address],
            destination_address: data[:destination_address],
            driver_id: driver.id,
            earnings: 12.0,
            score: rand(1..10),
            ride_distance: 5.0,
            ride_duration: 0.2,
            commute_distance: 10.0,
            commute_duration: 0.3
          )
          
      end
  
      get "/drivers/#{driver.id}/rides"
  
      expect(response).to have_http_status(:ok)
      expect(json['rides'].size).to eq(3)
      puts response.body
      puts response.status  
      expect(json['rides'].first['score'].to_f).to be >= json['rides'].last['score'].to_f

    end
  end
  

  # Helper method to parse JSON response
  def json
    JSON.parse(response.body)
  end
end
