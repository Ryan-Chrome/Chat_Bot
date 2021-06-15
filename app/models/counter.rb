class Counter < ApplicationRecord
  validates :name, presence: true
  validates :start_time, presence: true
  validates :stop_time, presence: true
end
