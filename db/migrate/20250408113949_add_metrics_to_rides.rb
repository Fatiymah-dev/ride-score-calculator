class AddMetricsToRides < ActiveRecord::Migration[8.0]
  def change
    add_column :rides, :commute_distance, :float
    add_column :rides, :commute_duration, :float
    add_column :rides, :ride_distance, :float
    add_column :rides, :ride_duration, :float
    # add_column :rides, :earnings, :float
    # add_column :rides, :score, :float
  end
end
