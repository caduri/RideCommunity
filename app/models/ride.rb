class Ride < ActiveRecord::Base
	belongs_to :user
	validates :comment, length: { maximum: 140 }
	validates :user_id, presence: true
	validates :addressto, presence: true
	validates_datetime :scheduledfor, :after => lambda { DateTime.current }
	geocoded_by :ip_address
	geocoded_by :addressto
	after_validation :geocode_both
	has_many :hitchhikes, dependent: :destroy

	def user_address
		Geocoder.address([self.latitude, self.longitude])
	end

	def calculate_distance
		'%.2f' % Geocoder::Calculations.distance_between([self.latitude, self.longitude], [self.destlatitude, self.destlongitude], {:units => :km})
	end

	def join_ride?(user)
		hitchhikes.find_by(user_id: user.id)
	end

	def eligible_to_join?
		num_of_hitchhikes = hitchhikes.count
		
		!((num_of_hitchhikes == 4) || (user.vehicle_type == "Motorcycle" && num_of_hitchhikes == 1) || 
		  (user.age <= 21 && num_of_hitchhikes == 2) || (user.gender == "Female" && num_of_hitchhikes == 3))
	end

	def join_ride!(user)
		hitchhikes.create!(user_id: user.id)
	end

	def unjoin_ride!(user)
		hitchhikes.find_by(user_id: user.id).destroy!
	end

	def self.by_distance_and_date(user)
		future_rides = where("scheduledfor > :current_date and user_id <> :user_id", current_date: DateTime.now, user_id: user.id)

		distance = 1
		geoResultByUserIP = Geocoder.search(ip_address)
		center_point = [geoResultByUserIP[0].latitude, geoResultByUserIP[0].longitude]
		box = Geocoder::Calculations.bounding_box(center_point, distance, {:latitude => "latitude", :longitude => "longitude", :units => :km})
		future_rides.within_bounding_box(box)
		#Ride.near(center_point, distance, {:latitude => "latitude", :longitude => "longitude", :units => :km})
	end

	def self.ip_address
		if Rails.env.development?
			"81.218.191.82" #ramla hardcoded ip
			#"89.139.176.156" #home hardcoded ip
			#"89.139.176.156" #um kultum tel aviv hard coded ip
		else
			request.remote_ip
		end
	end

	private

		def ip_address
			if Rails.env.development?
				"81.218.191.82" #ramla hardcoded ip
				#"89.139.176.156" #home hardcoded ip
				#"89.139.176.156" #um kultum tel aviv hard coded ip
			else
				request.remote_ip
			end
		end

		def geocode_both
			geoResultForAddress = Geocoder.search(self.addressto)
			if geoResultForAddress.blank? || geoResultForAddress[0].blank?
				errors.add(:base, "Destination address is not valid.")
			else
				self.destlatitude = geoResultForAddress[0].latitude
				self.destlongitude = geoResultForAddress[0].longitude
			end

			geoResultForIP = Geocoder.search(ip_address)
			if geoResultForIP.blank? || geoResultForIP[0].blank?
				errors.add(:base, "IP address is not valid.")
			else
				self.latitude = geoResultForIP[0].latitude
				self.longitude = geoResultForIP[0].longitude
			end
		end
end
