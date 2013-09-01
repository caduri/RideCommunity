class User < ActiveRecord::Base
  has_many :messages, dependent: :destroy
  has_many :rides, dependent: :destroy
  has_many :hitchhikes, through: :reverse_relationships, source: :user
  has_many :reverse_relationships, foreign_key: "user_id",
                                   class_name:  "Hitchhike",
                                   dependent:   :destroy

	has_secure_password  
  before_save { email.downcase! }
 	before_save :create_remember_token

	validates :name, presence: true, length: { maximum: 50 }
  validates :vehicle_type, presence: true
  validates :gender, presence: true
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: 	true, 
 					  format: 		{ with: VALID_EMAIL_REGEX }, 
  				  uniqueness: 	{ case_sensitive: false }
  validates :age, presence: true, length: { maximum: 5 }
  validates :password_confirmation, presence: true
 	validates :password, length: { minimum: 6 }

  def feed
    Ride.by_distance_and_date(self)
  end

  def add_message!(user, ride, action)
    message = "#{user.name} #{action} your ride to #{ride.addressto} at #{ride.scheduledfor}"
    Message.create!(content: message, seen: false, user_id: ride.user.id)
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
