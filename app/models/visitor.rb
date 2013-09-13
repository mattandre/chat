class Visitor < ActiveRecord::Base

        belongs_to :client
        has_many :messages, as: :messagable
        has_many :chats, through: :messages

	before_create :create_remember_token
	before_save do
		email.downcase!
	end

	def Visitor.new_remember_token
		token = loop do
        		random_token = SecureRandom.urlsafe_base64(nil, false)
        		break random_token unless Visitor.where(api_token: random_token).exists?
    		end
  	end

	def Visitor.encrypt(token)
        	unless token.nil?
        		Digest::SHA1.hexdigest(token)
    		end
  	end

	private

    		def create_remember_token
      			self.remember_token = Visitor.encrypt(Visitor.new_remember_token)
    		end

end
