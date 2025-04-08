class CreateRides < ActiveRecord::Migration[8.0]
  def change
    create_table :rides do |t|
      t.string :start_address
      t.string :destination_address
      t.references :driver, null: false, foreign_key: true
      t.decimal :earnings
      t.integer :duration
      t.decimal :score

      t.timestamps
    end
  end
end
