class Guestmailer < ApplicationMailer

  def receive_invitation(guest)
    @guest = guest

    mail(to: @guest.email, subject: "They like you! You have received an invitation")
  end

  def payment_confirmed(guest)
    @guest = guest

    mail(to: @guest.email, subject: "You have confirmed payment by paying us")
  end

  def experience_completed(guest)
    @guest = guest

    mail(to: @guest.email, subject: "You just had a wonderful time! Why don't you tell people?")
  end
end
