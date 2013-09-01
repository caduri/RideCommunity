class Hitchhike < ActiveRecord::Base
	belongs_to :ride
	belongs_to :user
	validates :ride_id, presence: true
	validates :user_id, presence: true
end
