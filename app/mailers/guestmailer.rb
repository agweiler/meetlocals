class Guestmailer < ApplicationMailer

  def receive_invitation(guest,booking)
    @guest = guest
    @booking = booking
    mail(to: @guest.email, subject: "They like you! Your booking status has been changed")
  end

  def payment_confirmed(guest,booking)
    @guest = guest

    mail(to: @guest.email, subject: "You have confirmed payment by paying us")
  end

  def experience_completed(guest)
    @guest = guest

    mail(to: @guest.email, subject: "You just had a wonderful time! Why don't you tell people?")
  end

  def guest_get_mail(guest,booking)
    @guest = guest
    @booking = booking
    mail(to: @guest.email, subject: "You got mail!")
  end
end
