# app/controllers/rides_controller.rb
class RidesController < ApplicationController
  before_action :find_driver, only: [ :index, :create ]
  def index
    rides = @driver.rides.ordered_by_score

    paginated_rides = rides.page(params[:page]).per(10)

    render json: {
      rides: paginated_rides.as_json(only: [ :id, :start_address, :destination_address, :score, :earnings, :ride_distance, :ride_duration, :commute_distance, :commute_duration ]),
      current_page: paginated_rides.current_page,
      total_pages: paginated_rides.total_pages
    }
  end

  def create
    ride = @driver.rides.build(ride_params)
    calculator = RideCalculator.new(@driver.home_address, ride.start_address, ride.destination_address)

    calculations = calculator.calculate_all
    ride.assign_attributes(
      commute_distance: calculations[:commute_distance],
      commute_duration: calculations[:commute_duration],
      ride_distance: calculations[:ride_distance],
      ride_duration: calculations[:ride_duration],
      earnings: calculations[:earnings],
      score: calculations[:score]
    )

    if ride.save
      render json: ride, status: :created
    else
      render json: { errors: ride.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def ride_params
    params.require(:ride).permit(:start_address, :destination_address, :driver_id)
  end

  def find_driver
    @driver = Driver.find(params[:driver_id])
  end
end
