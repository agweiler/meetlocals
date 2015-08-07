class Hostmailer < ApplicationMailer

  def receive_booking_request(host_id,booking_id,guest_id)
    @host = Host.find host_id
    @booking = Booking.find booking_id
    @guest = Guest.find guest_id
    mail(to: @host.email, subject: "Hurray! You have received a booking request")
  end

  def payment_completion(host_id, booking_id)
    @host = Host.find host_id
    @booking = Booking.find booking_id
    @guest = @booking.guest
    mail(to: @host.email, subject: "Payment has been completed!!!")
  end

  def host_get_mail(host_id,booking_id,new_message_id)
    @host = Host.find host_id
    @booking = Booking.find booking_id
    @message = Message.find new_message_id
    mail(to: @host.email, subject: "You got mail!")
  end

  def host_approved(host_id)
    @host = Host.find host_id
    mail(to: @host.email, subject: "You have been approved")
  end

  def event_reminder(booking_id,host_id,day)
    @booking = Booking.find booking_id
    @host = Host.find host_id
    @day = day
    mail(to: @host.email, subject: "Reminder! You have an upcoming event!")
  end
end
