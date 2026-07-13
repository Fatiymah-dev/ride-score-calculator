# app/services/ride_calculator.rb
require "faraday"
require "json"

class RideCalculator
  BASE_URL = ENV["OPEN_ROUTE_BASE_URL"]
  API_KEY = ENV["OPENROUTESERVICE_API_KEY"]

  def initialize(driver_home, ride_start, ride_end)
    @driver_home_address = driver_home
    @ride_start_address = ride_start
    @ride_end_address = ride_end

    @conn = Faraday.new(BASE_URL) do |f|
      f.request :url_encoded
      f.adapter Faraday.default_adapter
      f.headers["Authorization"] = API_KEY
      f.headers["Content-Type"] = "application/json"
    end

    @coordinates = {}
    threads = [ @driver_home_address, @ride_start_address, @ride_end_address ].map do |addr|
      Thread.new { @coordinates[addr] = geocode_address(addr) }
    end
    threads.each(&:join)

    @driver_home_coords = @coordinates[@driver_home_address]
    @ride_start_coords = @coordinates[@ride_start_address]
    @ride_end_coords = @coordinates[@ride_end_address]
  end

  def calculate_all
    commute = calculate_distance_duration(@driver_home_coords, @ride_start_coords)
    ride = calculate_distance_duration(@ride_start_coords, @ride_end_coords)

    earnings = calculate_earnings(ride[:distance], ride[:duration])
    score = earnings / (commute[:duration] + ride[:duration])

    {
      commute_distance: commute[:distance],
      commute_duration: commute[:duration],
      ride_distance: ride[:distance],
      ride_duration: ride[:duration],
      earnings: earnings,
      score: score
    }
  end

  private

  def geocode_address(address)
    cached_coords = Rails.cache.fetch("geo:#{address}", expires_in: 7.days) do
      response = @conn.get("/geocode/search", { text: address, boundary_country: "US" })
      coords = JSON.parse(response.body)["features"].first["geometry"]["coordinates"]
      coords
    end

    cached_coords
  end

  def calculate_distance_duration(from_coords, to_coords)
    cache_key = "dist:#{from_coords.join(',')}-#{to_coords.join(',')}"
    cached_data = Rails.cache.fetch(cache_key, expires_in: 1.day) do
      response = @conn.post("/v2/directions/driving-car", {
        coordinates: [ from_coords, to_coords ]
      }.to_json)

      data = JSON.parse(response.body)["routes"].first["summary"]
      distance_miles = data["distance"].to_f / 1609.34
      duration_hours = data["duration"].to_f / 3600.0

      { distance: distance_miles.round(2), duration: duration_hours.round(2) }
    end

    cached_data
  end

  def calculate_earnings(distance_miles, duration_hours)
    duration_minutes = duration_hours * 60

    extra_miles = [ distance_miles - 5, 0 ].max
    extra_minutes = [ duration_minutes - 15, 0 ].max

    12 + (1.5 * extra_miles) + (0.70 * extra_minutes)
  end
end
