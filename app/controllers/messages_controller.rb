class MessagesController < ApplicationController
  def new
    @message = params[:message]
    Message.create(text: @message[:text],
                  sender_id: @message[:sender_id],
                  sender_type: @message[:sender_type],
                  booking_id: @message[:booking_id]  )

    redirect_to "/bookings/#{@message[:booking_id]}"
  end

end
