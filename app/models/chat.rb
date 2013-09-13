class Chat < ActiveRecord::Base

	belongs_to :client
	has_many :messages

end
