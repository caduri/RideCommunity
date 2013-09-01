class MessagesController < ApplicationController
  before_action :signed_in_user

  def update
    @message = Message.find(params[:id])
    @message.update_attribute(:seen, true)
    respond_to do |format|
      format.html { redirect_to @message.user }
      format.js
    end
  end

  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    redirect_to my_messages_user_path(@message.user)
  end
end