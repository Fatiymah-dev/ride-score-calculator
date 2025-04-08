class RideSerializer < ActiveModel::Serializer
  attributes :id, :start_address, :destination_address, :score,
             :earnings, :ride_distance, :ride_duration,
             :commute_distance, :commute_duration
end
