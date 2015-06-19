class MessagesController < ApplicationController

  def new
    @message = params[:message]
    new_message = Message.create(text: @message[:text],
                    sender_id: @message[:sender_id],
                    sender_type: @message[:sender_type],
                    booking_id: @message[:booking_id]  )

    booking = new_message.booking
    if new_message.sender_type == "host"
      guest = Guest.find(booking.guest_id)
      host = booking.experience.host
      new_notification = guest.notifications.find_or_create_by(content: "Message from #{guest.first_name}", type_of: "messages", type_id: "#{booking.id}")
      new_notification.update(updated_at: Time.now, seen: false)
      Guestmailer.guest_get_mail(guest.id, booking.id, new_message.id,host.id).deliver_later
    elsif new_message.sender_type == "guest"
      host = Host.find(booking.experience.host_id)
      new_notification = host.notifications.find_or_create_by(content: "Message from #{host.first_name}", type_of: "messages", type_id: "#{booking.id}")
      new_notification.update(updated_at: Time.now, seen: false)
      Hostmailer.host_get_mail(host.id, booking.id, new_message.id).deliver_later
      Guestmailer.guest_get_mail(guest.id, booking.id, new_message.id).deliver_later
    elsif new_message.sender_type == "guest"
      host = Host.find(booking.experience.host_id)
      Hostmailer.host_get_mail(host.id, booking.id, new_message.id).deliver_later
    end

    respond_to do |format|
      # format.html {redirect_to booking_path new_message.booking_id}
      format.js
    end

  end

end
