class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy, :mark_completion]


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
      unless current_host.id == @experience.host_id
        redirect_to '/bookings', notice: "You are not logged in as the booking's host"
      end
    elsif guest_signed_in?
      unless current_guest.id == @booking.guest_id
        redirect_to '/bookings', notice: "You are not logged in as the booking's guest"
      end
    elsif admin_signed_in?
      puts "Viewing booking #{@booking.id}, status: #{@booking.payment_status}"
    else
      redirect_to '/bookings', notice: "You must be logged in to view your bookings"
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
    @action = request.filtered_parameters['action']
    @booking = @experience.bookings.find(params[:id])
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

    # if @experience.date
    #   starttime = @experience.date
    # else
    #   #moment.js foramt MMMM DD, YYYY
    #   starttime = DateTime.strptime(params[:datetime], '%B %d, %Y')
    # end

    # booking_params['date(1i)'].replace( starttime.strftime('%Y') )
    # booking_params['date(2i)'].replace( starttime.strftime('%m') )
    # booking_params['date(3i)'].replace( starttime.strftime('%d') )

    # @experience = Experience.find(booking_params[:experience_id])
    #
    # booking_params['start_time(1i)'].replace( starttime.strftime('%Y') )
    # booking_params['start_time(2i)'].replace( starttime.strftime('%m') )
    # booking_params['start_time(3i)'].replace( starttime.strftime('%d') )
    # booking_params['start_time(4i)'].replace( starttime.strftime('%H') )
    # booking_params['start_time(5i)'].replace( starttime.strftime('%M') )
    # # booking_params['start_time(6i)'].replace( starttime.strftime('%S') )
    #
    # endtime = starttime + Experience.find(booking_params[:experience_id]).duration.hour
    #
    # booking_params['end_time(1i)'].replace( endtime.strftime('%Y') )
    # booking_params['end_time(2i)'].replace( endtime.strftime('%m') )
    # booking_params['end_time(3i)'].replace( endtime.strftime('%d') )
    # booking_params['end_time(4i)'].replace( endtime.strftime('%H') )
    # booking_params['end_time(5i)'].replace( endtime.strftime('%M') )
    # # booking_params['start_time(6i)'].replace( endtime.strftime('%S') )

    @booking = @experience.bookings.new(booking_params)

    respond_to do |format|
      if @booking.save
        host = @booking.experience.host
        guest = @booking.guest
        Hostmailer.receive_booking_request(host.id,@booking.id,guest.id).deliver_now
        format.html { redirect_to [@experience, @booking], notice: 'Booking was successfully created.' }
      else
        format.html { render :new }
      end

    end
  end

  # PATCH/PUT /bookings/1
  def update
    booking_params[:status].replace( Booking.update_status(booking_params[:status]) )

    # starttime = Time.parse( params[:datetime] )

    #moment.js foramt MMMM DD, YYYY
    starttime = DateTime.strptime(params[:datetime], '%B %d, %Y')

    booking_params['date(1i)'].replace( starttime.strftime('%Y') )
    booking_params['date(2i)'].replace( starttime.strftime('%m') )
    booking_params['date(3i)'].replace( starttime.strftime('%d') )

    # booking_params['start_time(1i)'].replace( starttime.strftime('%Y') )
    # booking_params['start_time(2i)'].replace( starttime.strftime('%m') )
    # booking_params['start_time(3i)'].replace( starttime.strftime('%d') )
    # booking_params['start_time(4i)'].replace( starttime.strftime('%H') )
    # booking_params['start_time(5i)'].replace( starttime.strftime('%M') )
    # # booking_params['start_time(6i)'].replace( starttime.strftime('%S') )
    #
    # endtime = starttime + @booking.experience.duration.hour
    #
    # booking_params['end_time(1i)'].replace( endtime.strftime('%Y') )
    # booking_params['end_time(2i)'].replace( endtime.strftime('%m') )
    # booking_params['end_time(3i)'].replace( endtime.strftime('%d') )
    # booking_params['end_time(4i)'].replace( endtime.strftime('%H') )
    # booking_params['end_time(5i)'].replace( endtime.strftime('%M') )
    # # booking_params['start_time(6i)'].replace( endtime.strftime('%S') )
    @experience = Experience.find(params[:booking][:experience_id])

    respond_to do |format|
      if @booking.update(booking_params)
        guest = @booking.guest
        if booking_params[:status] == "invited"
          Guestmailer.receive_invitation(guest.id,@booking.id).deliver_now
        elsif booking_params[:status] == "rejected"
          Guestmailer.reject_invitation(guest.id,@booking.id).deliver_now
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
    @booking.destroy
    respond_to do |format|
      format.html { redirect_to bookings_url, notice: 'Booking was successfully removed.' }
      format.json { head :no_content }
    end
  end


  def mark_completion
    @booking.mark_as_complete

    respond_to :js
  end


  # Paypal sends this
  protect_from_forgery except: [:hook]
  def hook
    byebug
    params.permit! # Permit all Paypal input params
    status = params[:payment_status]
    id = params[:invoice].scan(/\d+/).first
    if status == "Completed"
      @booking = Booking.find id
      guest = @booking.guest
      host = @booking.experience.host
      Guestmailer.payment_confirmed(guest.id, @booking.id).deliver_now
      Hostmailer.payment_completion(host.id, @booking.id).deliver_now
      @booking.update_attributes notification_params: params, status: "confirmed", transaction_id: params[:txn_id], purchased_at: Time.now
    else
      puts "FAILED!!!"
    end
    render nothing: true
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
