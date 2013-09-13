class Group < ActiveRecord::Base
	
	belongs_to :client
	has_and_belongs_to_many :users

	validates :name, presence: true, length: { minimum: 5, maximum: 50 }

	scope :same_client_as, ->(user) { where("client_id = ?", user.client_id) }	

end
