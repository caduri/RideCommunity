class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def show
    @user = User.find(params[:id])
  end

  def new
    if signed_in?
      redirect_to root_path, notice: "You are already a member."
    else
      @user = User.new
    end
  end

  def create
    if signed_in?
      redirect_to root_path, notice: "You are already a member."
    else
      @user = User.new(user_params)
      if @user.save
      	sign_in @user
        flash[:success] = "Welcome to the Sample App!"
        redirect_to @user
      else
        render 'new'
      end
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    userToDelete = User.find(params[:id])
    if (current_user == userToDelete)
      flash[:error] = "Can not delete own admin account!"
    else
      userToDelete.destroy
      flash[:success] = "User destroyed."
    end
    redirect_to users_url
  end

  def myRides
    @title = "Own Rides"
    @user = User.find(params[:id])
    @rides = @user.rides.order("created_at DESC").paginate(page: params[:page])
    render 'show_my_rides'
  end

  def my_messages
    @title = "My Messages"
    @user = User.find(params[:id])
    @messages = @user.messages.order("created_at DESC").paginate(page: params[:page])
    render 'show_my_messages'
  end

  def join_rides
    @title = "Join Rides"
    @user = User.find(params[:id])
    
    ride_ids = "SELECT ride_id FROM hitchhikes
                WHERE user_id = :user_id"
    @rides = Ride.where("id in (#{ride_ids})", user_id: @user.id).paginate(page: params[:page])
    render 'show_join_rides'
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation,
                                   :age, :gender, :vehicle_type)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end