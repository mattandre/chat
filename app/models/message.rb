class Message < ActiveRecord::Base

	belongs_to :messagable, polymorphic: true
	belongs_to :chat
	belongs_to :user
	validates :content, presence: true

end
