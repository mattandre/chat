class ClientsController < ApplicationController
	#Filters
  before_action :set_client, only: [:show, :edit, :update, :destroy]

	skip_before_action :require_signed_in_user, only: [:new, :create]

  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def show
  end

  def new
  	@client = Client.new
    @user = @client.users.build
  end

  def create
    @client = Client.new(client_params)
    @owner = @client.users.first
    @client.owner = @owner

    if @client.save
    	sign_in @owner
    	flash[:success] = "Welcome!"
      redirect_to @owner
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to @client, notice: 'Client was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @client.destroy
    respond_to do |format|
      format.html { redirect_to clients_url }
      format.json { head :no_content }
    end
  end

  private
    def set_client
      @client = Client.find(params[:id])
    end

    def client_params
      params.require(:client).permit(:owner_id, users_attributes: [:name, :email, :password, :password_confirmation])
    end

    # Before filters

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
