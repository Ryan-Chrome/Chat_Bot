class Playlist < ApplicationRecord
  validates :video_id, presence: true
  validates :title, presence: true
end
