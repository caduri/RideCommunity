class RidesController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def new
    @ride = Ride.new
  end

  def create
    @ride = current_user.rides.build(ride_params)
    if @ride.save
      flash[:success] = "Ride created!"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def destroy
    @ride.destroy
    flash[:success] = "Ride deleted."
    redirect_to root_url
  end

  def edit
    @ride = Ride.find(params[:id])
  end

  def update
    @ride = Ride.find(params[:id])
    if @ride.update_attributes(ride_params)
      flash[:success] = "Ride updated"
      redirect_to myRides_user_path(@ride.user)
    else
      render 'edit'
    end
  end

  private

    def ride_params
      params.require(:ride).permit(:comment, :addressto, :scheduledfor)
    end

    def correct_user
      @ride = current_user.rides.find_by(id: params[:id])
      redirect_to root_url if @ride.nil?
    end
end