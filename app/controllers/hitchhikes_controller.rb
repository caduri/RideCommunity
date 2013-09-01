class HitchhikesController < ApplicationController
  before_action :signed_in_user

  def create
    @user = User.find(params[:hitchhike][:user_id])
    @ride = Ride.find(params[:hitchhike][:ride_id])
    @ride.join_ride!(@user)
    @user.add_message!(@user, @ride, "join")
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Hitchhike.find(params[:id]).user
    @ride = Hitchhike.find(params[:id]).ride
    @ride.unjoin_ride!(@user)
    @user.add_message!(@user, @ride, "unjoin")
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end