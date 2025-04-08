class RemoveDurationFromRides < ActiveRecord::Migration[8.0]
  def change
    remove_column :rides, :duration, :integer
  end
end
