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
    mail(to: @host.email, subject: "Payment has been completed!!!")
  end

  def host_get_mail(host_id,booking_id)
    @host = Host.find host_id
    @booking = Booking.find booking_id
    mail(to: @host.email, subject: "You got mail!")
  end
  
end
