class Hostmailer < ApplicationMailer

  def receive_booking_request(host)
    @host = host

    mail(to: @host.email, subject: "Hurray! You have received a booking request")
  end

  def payment_completion(host, booking)
    @host = host
    @booking = booking
    mail(to: @host.email, subject: "Payment has been completed!!!")
  end

  def host_get_mail(host,booking)
    @host = host
    @booking = booking
    mail(to: @host.email, subject: "You got mail!")
  end
  
end
