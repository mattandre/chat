class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :set_client, only: [:create]

  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @groups = Group.same_client_as(current_user)
  end

  def show
  end

  def new
    @group = Group.new
  end

  def create
    @group = @client.groups.new(group_params)

    if @group.save
      redirect_to @group, notice: 'Group was successfully created.'
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to @group, notice: 'Group was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_url, notice: 'Group was successfully destroyed.'
  end

  private
    def set_group
      @group = Group.find(params[:id])
    end

    def set_client
      @client = Client.for_user(current_user)
    end

    def group_params
      params.require(:group).permit(:name)
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
