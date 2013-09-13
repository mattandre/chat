class User < ActiveRecord::Base

	VALID_EMAIL_REGEX = /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

	attr_accessor :password_current, :set_password_token_verify, :update_password_verify_method
	
	belongs_to :client, foreign_key: :client_id, class_name: "Client"
	has_one :owned_client, foreign_key: :owner_id, class_name: "Client"
	has_and_belongs_to_many :groups	
	has_many :messages, as: :messagable 
	has_many :chats, through: :messages

	validates :name, presence: true, length: { maximum: 50 }
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
	validates :title, length: { maximum: 80 }

	validates_presence_of     :password, if: :password_required?
	validates_confirmation_of :password, if: :password_required?
	validates_length_of       :password, within: 8..128, allow_blank: true
	validate :valid_current_password_or_set_password_token, on: :update, if: :password_required?

	has_secure_password

	scope :same_client_as, ->(user) { where("client_id = ?", user.client_id) }	

  before_create :create_remember_token
  before_save do 
  	email.downcase!
  end

  def owner?
    !self.owned_client.nil?
  end

  def sign_in(remember_token, ip)
  	self.update_attribute(:remember_token, User.encrypt(remember_token))
  	self.update_attribute(:ip, ip)
  end

  def update_password(params, verification_method)
  	self.assign_attributes(params)
    self.update_password_verify_method = verification_method
    self.valid? && (self.set_password_token = "") && self.save(validate: false) 
  end

  def User.new_random_password
    SecureRandom.urlsafe_base64(nil, false)
  end

  def User.new_set_password_token
    SecureRandom.urlsafe_base64(nil, false)
  end

  def User.new_remember_token
    token = loop do
    	random_token = SecureRandom.urlsafe_base64(nil, false)
    	break random_token unless User.where(remember_token: random_token).exists?
    end
  end

  def User.encrypt(token)
  	unless token.nil?
    	Digest::SHA1.hexdigest(token)
    end
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end

    def password_required?
      !persisted? || !password.nil? || !password_confirmation.nil?
    end

    def valid_current_password_or_set_password_token
      if update_password_verify_method == :token
				errors.add(:base, "Invalid password set token") unless self.set_password_token == User.encrypt(self.set_password_token_verify)
      else
    		errors.add(:password_current, "is invalid") unless self.authenticate(password_current)
      end
    end

end
