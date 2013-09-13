class UsersController < ApplicationController

	#Filters

	before_action :set_user, only: [:show, :edit, :update, :edit_password, :update_password, :activate, :update_activation, :reset_password,  :destroy]
	before_action :set_client, only: [:create]

	skip_before_action :require_signed_in_user, only: [:activate, :update_activation,  :forgot_password, :remind_password, :reset_password, :update_password]

  before_action :require_current_user, only: [:edit_password]
  before_action :require_current_or_admin_user,   only: [:edit, :update]
  before_action :require_admin_user,     only: [:new, :create, :destroy]

  before_action :require_valid_set_password_token, only: [:activate, :reset_password]

  def index
  	@users = User.same_client_as(current_user).paginate(page: params[:page])
  end

  def show
  end

  def new  	
    @user = User.new
  end

  def create
    @user = @client.users.new(user_params)
    @user.password = @user.password_confirmation = User.new_random_password
    set_password_token = User.new_set_password_token
    @user.set_password_token = User.encrypt(set_password_token)
    if @user.save
    	UserMailer.activate_email(@user, set_password_token).deliver
    	flash[:success] = "User created!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_update_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def edit_password
  end

  def update_password 
    verification_method = signed_in? && current_user?(@user) ? :password : :token
    if @user.update_password(user_password_params, verification_method)
      flash[:success] = "Password updated"
      sign_in @user
      redirect_to root_path
    elsif signed_in? && current_user?(@user)
      render 'edit_password'
    else
      render 'reset_password'
    end
  end

  def activate
    @user.set_password_token_verify = params[:set_password_token]
  end

  def update_activation
    if @user.update_password(user_password_params, :token)
      flash[:success] = "User activated"
      sign_in @user
      redirect_to root_path
    else
      render 'reset_password'
    end
  end

  def forgot_password
  end

  def remind_password
    @user = User.find_by email: params[:email]
    set_password_token = User.new_set_password_token
    if @user.update_attributes(set_password_token: User.encrypt(set_password_token))
      UserMailer.remind_password_email(@user, set_password_token).deliver
      flash[:success] = "Reset password instuctions were successfully sent."
      redirect_to root_path
    end
  rescue
    flash[:error] = "Unable to send password reset instructions. Please verify your email and try again."
    render 'forgot_password'
  end

  def reset_password
    @user.set_password_token_verify = params[:set_password_token]
  end

  def destroy
    @user.destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  private

  	#Model Setters

    def set_user
      @user = User.find(params[:id])
    end

    def set_client
      @client = Client.for_user(current_user)
    end

    #Params

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :password_current, :group_ids => [])
    end

    def user_update_params
      params.require(:user).permit(:name, :email, :group_ids => [])
    end

    def user_password_params
      params.require(:user).permit(:password, :password_confirmation, :password_current, :set_password_token_verify)
    end

    #Filters

	  def require_current_user
	    set_user
	    redirect_to(root_path) unless current_user?(@user)
	  end

	  def require_current_or_admin_user
	  	set_user
	  	redirect_to(root_path) unless current_user?(@user) || current_user.admin? || current_user.owner?
	  end

	  def require_valid_set_password_token
	  	set_user
	  	redirect_to(root_path) unless @user.set_password_token.present? && @user.set_password_token.present?  && User.encrypt(params[:set_password_token]) == @user.set_password_token
	  end

end
