class ChargesController < ApplicationController
  def new
  end

  def create
    @amount = ((params[:charges_info][:price].to_i * 100) * (2/100) + 2).to_i
    puts "@@@@@"
    puts @amount
    @booking = Booking.find params[:charges_info][:booking_id]
    @experience = @booking.experience
    customer = Stripe::Customer.create(
      :email => params[:charges_info][:stripeEmail],
      :source  => params[:charges_info][:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => "Guest for #{@experience.title}",
      :currency    => 'dkk'
    )

    if charge[:paid] 
      guest = @booking.guest
      host = @booking.experience.host
      # Guestmailer.payment_confirmed(guest.id, @booking.id,host.id).deliver_later
      # Hostmailer.payment_completion(host.id, @booking.id).deliver_later
      # Adminmailer.guest_has_payed(guest.id, host.id, @booking.id).deliver_later
      @booking.update_attributes  status: "confirmed", transaction_id: charge[:id], purchased_at: Time.now
      redirect_to payment_success_path and return
    end

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to booking_path(@booking)
  end


end
