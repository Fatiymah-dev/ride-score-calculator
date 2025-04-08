# app/models/driver.rb
class Driver < ApplicationRecord
  has_many :rides, dependent: :destroy
end
