class Message < ActiveRecord::Base
	belongs_to :user
	default_scope -> { order('created_at DESC') }
	validates :content, presence: true
	validates :user_id, presence: true

	def self.user_messages(user)
		where("user_id = :user_id", user_id: user.id)
	end
end
