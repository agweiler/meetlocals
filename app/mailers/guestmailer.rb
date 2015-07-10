class Guestmailer < ApplicationMailer

  def receive_invitation(guest_id,booking_id,host_id)
    @guest = Guest.find guest_id
    @booking = Booking.find booking_id
    @host = Host.find host_id
    mail(to: @guest.email, subject: "Your booking status has been changed")
  end

    def reject_invitation(guest_id,booking_id)
    @guest = Guest.find guest_id
    @booking = Booking.find booking_id
    mail(to: @guest.email, subject: "Sorry, they can't make it work")
  end

  def payment_confirmed(guest_id,booking_id,host_id)
    @guest = Guest.find guest_id
    @booking = Booking.find booking_id
    @host = Host.find host_id
    mail(to: @guest.email, subject: "You have confirmed payment by paying us")
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
    mail(to: @guest.email, subject: "You got mail!")
  end

  def create_booking_request(host_id,booking_id,guest_id)
  @guest = Guest.find guest_id
  @booking = Booking.find booking_id
  @host = Host.find host_id
  mail(to: @guest.email, subject: "You got mail!")
  end
end
