# RideCalculator App

## Overview
This app calculates ride information, including commute distance, ride distance, earnings, and score, by integrating with the OpenRouteService API. Optimizations have been made to reduce the number of API calls and improve performance through caching with Redis.

## Optimizations Made
1. **Geocoding Optimization:**
 The `geocode_address` method now uses **Redis caching** to store geocode results, reducing redundant API calls when the same address is queried multiple times.

2. **Distance Calculation Optimization:**
 The `calculate_distance_duration` method caches the results of distance and duration calculations between two coordinates to avoid repeated API calls for the same routes.

3. **Faraday Integration for API Requests:**
 Replaced the use of `HTTParty` with `Faraday` for better control over API calls, handling retries, and improving maintainability.

4. **Rails Cache with Redis:**
 Integrated Redis for caching purposes, improving speed by storing geocode results and distance calculations in the cache.

5. **Test Assertion Fix:**
 Fixed the test case that was failing due to string comparison issues by converting the `score` field to a numeric type for proper sorting validation. This ensures that rides are sorted correctly by score.

 To run the tests and ensure proper sorting functionality, use the following command:
 ```bash
 bundle exec rspec spec/integration/rides_integration_spec.rb

## Getting Started

Follow these instructions to run the app and tests on your local machine.

### 1. Install Dependencies

Clone the repository and install required gems:
```bash
git clone <git@github.com:Anniezolman/Hopeskipdrive-TA.git>
cd my_ride_app
bundle install
