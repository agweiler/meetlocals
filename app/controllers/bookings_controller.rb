class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy, :mark_completion, :cancel_booking]
  include ApplicationHelper

  # GET /bookings
  def index
    if no_one_signed_in?
      deny_access_host
    else
      @bookings = []

      current_host.experiences.each do |experience|
        @bookings << experience.bookings
      end if host_signed_in?

      @bookings = current_guest.bookings if guest_signed_in?
      @bookings = Booking.all if current_admin
      @bookings.flatten! if @bookings.respond_to?(:flatten!)
    end
  end

  # GET /bookings/1
  def show # Limited to only certain people
    
    if host_signed_in?
      Notification.where(host_id: current_user.id, type_id: @booking.id).update_all(seen: true) if Notification.find_by(host_id: current_user.id,type_id: @booking.id).present?
      unless current_host.id == @experience.host_id
        redirect_to '/bookings', notice: "You are not logged in as the booking's host"
      end
    elsif guest_signed_in?

      Notification.where(guest_id: current_user.id, type_id: @booking.id).update_all(seen: true) if Notification.find_by(guest_id: current_user.id, type_id: @booking.id).present?
      unless current_guest.id == @booking.guest_id
        redirect_to '/bookings', notice: "You are not logged in as the booking's guest"
      end
    elsif admin_signed_in?
      # puts "Viewing booking #{@booking.id}, status: #{@booking.payment_status}"
    else
      deny_access_guest
    end
    @messages = @booking.messages.all
    @message = Message.new
  end

  # GET /bookings/new
  def new
    redirect_to '/guests/sign_in' unless guest_signed_in?
    @experience = Experience.find(params[:id])
    @booking = @experience.bookings.new
  end

  # GET /bookings/1/edit
  def edit
    @host = @experience.host
    @action = request.filtered_parameters['action']
    @booking = @experience.bookings.find(params[:id])
    @date = @booking.date.strftime('%F')
  end

  # POST /bookings
  def create
    # @experience = Experience.find(booking_params.delete(:experience_id).to_i)
    @experience = Experience.find(params[:booking][:experience_id])
    booking_params[:guest_id].replace(current_guest.id.to_s)
    # starttime = Time.parse( params[:datetime] )

    if exp_date = @experience.date
      booking_params['date(1i)'].replace exp_date.strftime('%Y')
      booking_params['date(2i)'].replace exp_date.strftime('%-m')
      booking_params['date(3i)'].replace exp_date.strftime('%-d')
    end

    @booking = @experience.bookings.new(booking_params)
    @booking.start_time = @experience.time
    if @experience.meal == "Dinner"
      @booking.end_time = @experience.time + 3.hours
    elsif @experience.meal == "Lunch"
      @booking.end_time = @experience.time + 4.hours
    end
    
    respond_to do |format|
      if @booking.save
        host = @booking.experience.host
        guest = @booking.guest
        exp = @booking.experience
        Guestmailer.create_booking_request(host.id,@booking.id,guest.id).deliver_later
        Hostmailer.receive_booking_request(host.id,@booking.id,guest.id).deliver_later
        host.notifications.create(content: "You have a new booking for the #{exp.title} event", type_of: "bookings", type_id: "#{@booking.id}", seen: false)
        format.html { redirect_to [@experience, @booking], notice: 'Booking was successfully created.' }
      else
        format.html { render :new }
      end

    end
  end

  # PATCH/PUT /bookings/1
  def update
    booking_params[:status].replace( Booking.update_status(booking_params[:status]) )

    booking_params['date(1i)'].replace( params[:booking]["date(1i)"] )
    booking_params['date(2i)'].replace( params[:booking]["date(2i)"] )
    booking_params['date(3i)'].replace( params[:booking]["date(3i)"] )

    @experience = Experience.find(params[:booking][:experience_id])

    respond_to do |format|
      if @booking.update(booking_params)
        guest = @booking.guest
        host = @booking.experience.host
        if booking_params[:status] == "invited"
          Guestmailer.receive_invitation(guest.id,@booking.id,host.id).deliver_later
          guest.notifications.create(content: "Booking Status Updated", type_of: "bookings", type_id: "#{@booking.id}", seen: false)
        elsif booking_params[:status] == "rejected"
          guest.notifications.create(content: "Booking Status Updated", type_of: "bookings", type_id: "#{@booking.id}", seen: false)
          Guestmailer.reject_invitation(guest.id,@booking.id).deliver_later
        elsif booking_params[:status] == "completed"
          Guestmailer.experience_completed(@bookingid,guest.id).deliver_later
          Adminmailer.experience_completed(host.id, guest.id).deliver_later
        end
        format.html { redirect_to [@experience, @booking], notice: 'Booking was successfully updated.' }
        format.json { render :show, status: :ok, location: @booking }
      else
        format.html { render :edit }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    if current_user.class == Guest
      #subtracts number of days between current cancel date and booking date,turns it into an integer
      if (@booking.date - Time.current.to_date).to_i > 5
        paypal_refund(current_user.email)
      end
    end
    @booking.update(status: "canceled")
    respond_to do |format|
      format.html { redirect_to bookings_url, notice: 'Booking was successfully removed.' }
      format.json { head :no_content }
    end
  end


  def mark_completion
    @booking.mark_as_complete

    respond_to :js
  end

  def cancel_booking
    user_type = current_user.class.name
    @booking.cancel(user_type)
    respond_to :js
  end


  # Paypal sends this
  protect_from_forgery except: [:hook]
  def hook

    params.permit! # Permit all Paypal input params
    puts "@@@@@@@@@@"
    puts params
    puts "@@@@@@@@@@"
    # stat us = params[:payment_status]
    status = params[:payment_status]
    puts "@@@@@@@@@@"
    puts status
    puts "@@@@@@@@@@"
    id = params[:invoice].scan(/\d+/).first
    puts "@@@@@@@@@@"
    puts id
    puts "@@@@@@@@@@"
    if status == "Completed"
      puts id
      @booking = Booking.find(id.to_i)
      @booking.inspect
      guest = @booking.guest
      host = @booking.experience.host
      Guestmailer.payment_confirmed(guest.id, @booking.id,host.id).deliver_later
      Hostmailer.payment_completion(host.id, @booking.id).deliver_later
      @booking.update_attributes notification_params: params, status: "confirmed", transaction_id: params[:txn_id], purchased_at: Time.now
    else
    end
    render nothing: true ,notice: message
    # redirect_to booking_path(@booking)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
      @experience = Experience.find(@booking.experience_id) unless @booking.nil?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def booking_params
      params.require(:booking).permit(:start_time, :end_time, :date, :date_text, :guest_id, :experience_id, :status, :group_size, :is_private, :rating, :add_info)
    end
end
