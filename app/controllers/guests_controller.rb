class GuestsController < ApplicationController
  include ImagesHelper
  before_action :set_guest, only: [:show, :edit, :update, :destroy, :update_guest_profile]

	def index
		@guests = Guest.all
	end

  def show
    @guest = Guest.find(params[:id])
    @response = check_images_guest(@guest.id)
    respond_to do |format|
      format.js    { render json: @response }
      format.html
    end
    # @testimonials = @guest.bookings.testimonial
  end

  def new
    @guest = Guest.new
  end

  def edit
  end

  # POST /guests
  # We don't seem to be using this...
  def create
  end

  # PATCH/PUT /guests/1
  def update
    @image_file = params[:guest].delete(:image_file)
    @guest.update(guest_params)
    @guest.filled = true
    if @image_file.present?  
      if @guest.images.present?
        @guest.images.delete_all
      end
      @guest.images.create(local_image: @image_file, caption: @image_file.original_filename)
    end
    if @guest.save
      redirect_location = session[:host_page] || guest_path(@guest)
      session.delete(:host_page)
      respond_to do |format| 
        format.html { redirect_to redirect_location, notice: 'Guest profile was successfully updated.' }
      end
    end
  end

  # DELETE /guests/1
  def destroy
  	if @guest.images.present?
      @guest.images.delete_all
    end
    @guest.destroy
    respond_to do |format|
      format.html { redirect_to admins_url, notice: 'Guest was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def edit_guest_profile # Edit profile page
  	if current_guest == nil 
      deny_access_guest
    else
    @guest = Guest.find(params[:id])
    end
  end

  def update_guest_profile # Create and Edit guest profile
    @image_file = params[:guest].delete(:image_file)
    @guest.update(guest_params)
    if @image_file.present?  
      if @guest.images.present?
        @guest.images.delete_all
      end
      @guest.images.create(local_image: @image_file, caption: @image_file.original_filename)
    end
    if @guest.save
      respond_to do |format| 
        format.html { redirect_to edit_guest_profile, notice: 'Guest profile was successfully updated.' }
      end
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_guest
    @guest = Guest.find(params[:id])
  end

	# Never trust parameters from the scary internet, only allow the white list through.
  def guest_params
    params.require(:guest).permit(:username, :email, :password, :password_confirmation, :about, :remember_me, :image_file, :first_name, :last_name, :title, :languages, :nationality, :country, :interests, :allergies, :profession)
  end
end
