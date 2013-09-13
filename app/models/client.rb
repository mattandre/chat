class Client < ActiveRecord::Base

	belongs_to :owner, foreign_key: :owner_id, class_name: "User"
	has_many :users, foreign_key: :client_id, class_name: "User"
	has_many :visitors
	has_many :groups
	has_many :chats
	
	accepts_nested_attributes_for :users

	scope :for_user, ->(user) { where("id = ?", user.client_id).first }

	before_create :create_api_token

  private

    def create_api_token
      self.api_token = loop do
      	random_token = SecureRandom.urlsafe_base64(nil, false)
      	break random_token unless Client.where(api_token: random_token).exists?
      end
    end

end
