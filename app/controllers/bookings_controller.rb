class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy]

  # GET /bookings
  def index
    @bookings = []

    current_host.experiences.each do |experience|
      @bookings << experience.bookings
    end if host_signed_in?

    @bookings = current_guest.bookings if guest_signed_in?

    @bookings.flatten! if @bookings.respond_to?(:flatten!)
  end

  # GET /bookings/1
  def show
    @messages = @booking.messages.all
    @message = Message.new
  end

  # GET /bookings/new
  def new
    redirect_to '/guests/sign_in' unless guest_signed_in?
    @booking = Booking.new
    @experience = Experience.find(params[:id])
  end

  # GET /bookings/1/edit
  def edit
  end

  # POST /bookings
  def create
    # @experience = Experience.find(booking_params.delete(:experience_id).to_i)
    booking_params[:guest_id].replace(current_guest.id.to_s)

    # starttime = Time.parse( params[:datetime] )
    starttime = DateTime.strptime(params[:datetime], '%m/%d/%Y %I:%M %p')
    booking_params['date(1i)'].replace( starttime.strftime('%Y') )
    booking_params['date(2i)'].replace( starttime.strftime('%m') )
    booking_params['date(3i)'].replace( starttime.strftime('%d') )

    booking_params['start_time(1i)'].replace( starttime.strftime('%Y') )
    booking_params['start_time(2i)'].replace( starttime.strftime('%m') )
    booking_params['start_time(3i)'].replace( starttime.strftime('%d') )
    booking_params['start_time(4i)'].replace( starttime.strftime('%H') )
    booking_params['start_time(5i)'].replace( starttime.strftime('%M') )
    # booking_params['start_time(6i)'].replace( starttime.strftime('%S') )

    endtime = starttime + Experience.find(booking_params[:experience_id]).duration.hour

    booking_params['end_time(1i)'].replace( endtime.strftime('%Y') )
    booking_params['end_time(2i)'].replace( endtime.strftime('%m') )
    booking_params['end_time(3i)'].replace( endtime.strftime('%d') )
    booking_params['end_time(4i)'].replace( endtime.strftime('%H') )
    booking_params['end_time(5i)'].replace( endtime.strftime('%M') )
    # booking_params['start_time(6i)'].replace( endtime.strftime('%S') )

    @booking = Booking.new(booking_params)


    if @booking.save
      redirect_to @booking.paypal_url(booking_path(@booking))
    else
      render :new
    end
  end

  # PATCH/PUT /bookings/1
  def update

    booking_params[:status].replace( Booking.update_status(booking_params[:status]) )
    # starttime = Time.parse( params[:datetime] )
    starttime = DateTime.strptime(params[:datetime], '%m/%d/%Y %I:%M %p')
    booking_params['date(1i)'].replace( starttime.strftime('%Y') )
    booking_params['date(2i)'].replace( starttime.strftime('%m') )
    booking_params['date(3i)'].replace( starttime.strftime('%d') )

    booking_params['start_time(1i)'].replace( starttime.strftime('%Y') )
    booking_params['start_time(2i)'].replace( starttime.strftime('%m') )
    booking_params['start_time(3i)'].replace( starttime.strftime('%d') )
    booking_params['start_time(4i)'].replace( starttime.strftime('%H') )
    booking_params['start_time(5i)'].replace( starttime.strftime('%M') )
    # booking_params['start_time(6i)'].replace( starttime.strftime('%S') )

    endtime = starttime + @booking.experience.duration.hour

    booking_params['end_time(1i)'].replace( endtime.strftime('%Y') )
    booking_params['end_time(2i)'].replace( endtime.strftime('%m') )
    booking_params['end_time(3i)'].replace( endtime.strftime('%d') )
    booking_params['end_time(4i)'].replace( endtime.strftime('%H') )
    booking_params['end_time(5i)'].replace( endtime.strftime('%M') )
    # booking_params['start_time(6i)'].replace( endtime.strftime('%S') )

    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to @booking, notice: 'Booking was successfully updated.' }
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
      format.html { redirect_to bookings_url, notice: 'Booking was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # Paypal sends this
  protect_from_forgery except: [:hook]
  def hook
    puts "THIS IS A PAYPAL REQUEST REACHING HOOK "*5
    byebug
    puts "IT IS SUPPOSED TO HAPPEN ASYNCHRONOUSLY "*5
    byebug
    puts "REMOVE IT IF IT IS OF NO USE YET "*5
    byebug
    params.permit! # Permit all Paypal input params
    status = params[:payment_status]
    if status == "Completed"
      @registration = Registration.find params[:invoice]
      @registration.update_attributes notification_params: params, status: status, transaction_id: params[:txn_id], purchased_at: Time.now
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
      params.require(:booking).permit(:start_time, :end_time, :date, :guest_id, :experience_id, :status, :group_size, :is_private, :rating)
    end
end
