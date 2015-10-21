class Guestmailer < ApplicationMailer

  def receive_invitation(guest_id,booking_id,host_id)
    @guest = Guest.find guest_id
    @booking = Booking.find booking_id
    @host = Host.find host_id
    mail(to: @guest.email, subject: "Your dinner request has been accepted")
  end

    def reject_invitation(guest_id,booking_id)
    @guest = Guest.find guest_id
    @booking = Booking.find booking_id
    mail(to: @guest.email, subject: "Sorry, the host can't make it work")
  end

  def payment_confirmed(guest_id,booking_id,host_id)
    @guest = Guest.find guest_id
    @booking = Booking.find booking_id
    @host = Host.find host_id
    @google_map = "https://www.google.com/maps/place/#{@host.street_address} #{@host.suburb} #{@host.state}"
    mail(to: @guest.email, subject: "Details regarding your Meet the Danes event")
  end

  def experience_completed(booking_id,guest_id)
    @guest = Guest.find guest_id
    @booking = Booking.find booking_id
    mail(to: @guest.email, subject: "You just had a wonderful time! Why don't you tell people?")
  end

  def guest_get_mail(guest_id,booking_id,message_id,host_id)
    @guest = Guest.find guest_id
    @booking = Booking.find booking_id
    @message = Message.find message_id
    @host = Host.find host_id
    mail(to: @guest.email, subject: "You have a mail from your Meet the Danes host")
  end

  def create_booking_request(host_id,booking_id,guest_id)
    @guest = Guest.find guest_id
    @booking = Booking.find booking_id
    @host = Host.find host_id
    mail(to: @guest.email, subject: "You have requested a booking")
  end

  def host_cancel(guest_id,host_id,booking_id)
    @guest = Guest.find guest_id
    @host = Host.find host_id
    @booking = Booking.find booking_id
    mail(to: @guest.email, subject: "A host has canceled your booking")
  end
end
